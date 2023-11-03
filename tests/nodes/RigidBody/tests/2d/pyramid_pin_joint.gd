extends PhysicsUnitTest2D

@export var height := 5
@export var box_size := Vector2(50.0, 50.0)
@export var box_spacing :=  Vector2(50, 50)
var simulation_duration := 10
var size_boundary := 20

var bodies := []
var top_last_position := Vector2.ZERO

func test_description() -> String:
	return """Checks the stability of the RigidBody Simulation. The pyramid should be stable and the RigidBody
	should sleep after the [simulation_duration]
	"""
	
func test_name() -> String:
	return "Boxes Pyramid"

func test_start() -> void:
	create_pyramid()


func create_joint(node_a: PhysicsBody2D, node_b: PhysicsBody2D) -> Joint2D:
	var joint = PinJoint2D.new();
	#joint.damping = 1000
	#joint.stiffness = 20
	joint.softness = 0.7
	joint.node_a = node_a.get_path()
	joint.node_b = node_b.get_path()
	joint.disable_collision = false
	return joint

func create_pyramid():
	var pos_y = -0.5 * box_size.y - box_spacing.y + Global.WINDOW_SIZE.y - size_boundary
	var pos_x
	var count = 0
	var count_joint = 0
	var prev_row = []
	for level in height:
		var level_index = height - level - 1
		var num_boxes = height

		var row_node = Node2D.new()
		row_node.position = Vector2(0.0, pos_y)
		row_node.name = "Row%02d" % (level + 1)
		add_child(row_node)
		bodies.append(row_node)

		pos_x = -0.5 * (num_boxes - 1) * (box_size.x + box_spacing.x) + Global.WINDOW_SIZE.x/2
		var current_row = []
		var prev_rb : PhysicsBody2D
		for box_index in range(num_boxes):
			var box = get_rigid_body()
			if box_index == num_boxes / 2 && level == height - 1:
				box = get_static_body()
			box.position = Vector2(pos_x, 0.0)
			box.name = "Box%02d" % (box_index + 1)
			current_row.append(box)
			row_node.add_child(box)
			# link prev item
			if prev_rb != null:
				var joint = create_joint(box, prev_rb)
				box.add_child(joint)
				count_joint +=1
				if !prev_row.is_empty():
					var joint2 = create_joint(box, prev_row[box_index])
					box.add_child(joint2)
					count_joint +=1
			prev_rb = box
			count += 1

			pos_x += box_size.x + box_spacing.x
		prev_row = current_row
		pos_y -= box_size.y + box_spacing.y
	print (height, " ", count, " ", count_joint)
	top_last_position = Vector2(pos_x - box_size.x + box_spacing.x,  pos_y +  box_size.y - box_spacing.y)
		
func get_rigid_body() -> RigidBody2D:
	var body = RigidBody2D.new()
	body.mass = 0.05
	var shape = PhysicsTest2D.get_collision_shape(Rect2(Vector2(0, 0), box_size), TestCollisionShape.RECTANGLE, false)
	body.add_child(shape)
	return body

func get_static_body() -> StaticBody2D:
	var body = StaticBody2D.new()
	var shape = PhysicsTest2D.get_collision_shape(Rect2(Vector2(0, 0), box_size), TestCollisionShape.RECTANGLE, false)
	body.add_child(shape)
	return body
