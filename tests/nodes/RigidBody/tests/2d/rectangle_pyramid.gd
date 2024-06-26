extends PhysicsUnitTest2D

@export var next_scene_name = ""
@export var height := 80
@export var box_size := Vector2(100.0, 100.0)
@export var box_spacing :=  Vector2(0.002, 0.002)
var simulation_duration := 280
var size_boundary := 20

var bodies := []
var top_last_position := Vector2.ZERO

func test_description() -> String:
	return """Checks the stability of the RigidBody Simulation. The pyramid should be stable and the RigidBody
	should sleep after the [simulation_duration]
	"""
	
func test_name() -> String:
	return "Boxes Pyramid"

func test_start() -> String:
	add_ground(size_boundary)
	create_pyramid()

	var test_sleep: Callable = func(_p_target: PhysicsTest2D, _p_monitor: GenericExpirationMonitor):
		for body_parent in bodies as Array[Node2D]:
			var body: RigidBody2D = body_parent.get_child(0)
			if not body.sleeping:
				return false
		return true
	
	var test_head_position: Callable = func(_p_target: PhysicsTest2D, p_monitor: GenericExpirationMonitor):

		
		return true
			
	var pyramid_sleep := create_generic_expiration_monitor(self, test_sleep, null, simulation_duration)
	pyramid_sleep.test_name = "All body are sleep"
	
	var pyramid_top_cube := create_generic_expiration_monitor(self, test_head_position, null, simulation_duration)
	pyramid_top_cube.test_name = "The top cube did not move"
	return next_scene_name

func create_pyramid():
	var pos_y = -0.5 * box_size.y - box_spacing.y + Global.WINDOW_SIZE.y - size_boundary
	var pos_x
	var count = 0
	for level in height:
		var level_index = height - level - 1
		var num_boxes = 2 * level_index + 1

		var row_node = Node2D.new()
		row_node.position = Vector2(0.0, pos_y)
		row_node.name = "Row%02d" % (level + 1)
		add_child(row_node)
		count += 1
		bodies.append(row_node)

		pos_x = -0.5 * (num_boxes - 1) * (box_size.x + box_spacing.x) + Global.WINDOW_SIZE.x/2

		for box_index in range(num_boxes):
			var box = get_rigid_body()
			box.position = Vector2(pos_x, 0.0)
			box.name = "Box%02d" % (box_index + 1)
			box.mass = 100
			row_node.add_child(box)
			count += 1

			pos_x += box_size.x + box_spacing.x

		pos_y -= box_size.y + box_spacing.y
	print (count)
	top_last_position = Vector2(pos_x - box_size.x + box_spacing.x,  pos_y +  box_size.y - box_spacing.y)
		
func get_rigid_body() -> RigidBody2D:
	var body = RigidBody2D.new()
	var shape = PhysicsTest2D.get_collision_shape(Rect2(Vector2(0, 0), box_size), TestCollisionShape.RECTANGLE, false)
	body.add_child(shape)
	return body
