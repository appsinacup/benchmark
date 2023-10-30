extends PhysicsUnitTest2D

var stack_height := 50
var max_horizontal_movement := 5.0
var body_size := Vector2(25, 25)
var body_spacing := 1
@export var body_shape:= PhysicsTest2D.TestCollisionShape.CIRCLE

func test_description() -> String:
	return """Checks the stability of the RigidBody Simulation. The stack should be stable and the RigidBody
	should sleep after the [simulation_duration]
	"""
	
func test_name() -> String:
	return "RigidBody2D | testing the box stack stability"

func test_start() -> void:
	add_collision_boundaries(20, false)

	var stack = Node2D.new()
	stack.position = BOTTOM_CENTER - Vector2(0, 20 + -body_size.y * 0.5)
	
	var bodies_array : Array[RigidBody2D] = []
	for i in range(stack_height):
		var body := RigidBody2D.new()
		var body_col: Node2D = PhysicsTest2D.get_default_collision_shape(body_shape, 1)
		body.add_child(body_col)
		
		# Spawn the body
		body.position = Vector2(0, -(body_size.y + body_spacing) * (i+1))
		bodies_array.append(body)
		stack.add_child(body)
	
	add_child(stack)
	
