extends PhysicsUnitTest2D

var timer: Timer
@export var type:= TestCollisionShape.CIRCLE
@export var next_scene_name = ""
@export var interval := 0.03

var bodies : Array[RigidBody2D] = []

func test_description() -> String:
	return """In this benchmark, there are about X small cubes falling on a large cubic "cup" in a completely unordered way.
	"""
	
func test_name() -> String:
	return "Falling " + shape_name(type)

func test_start() -> String:
	add_collision_boundaries_extend(20, false, 2)

	timer = Timer.new()
	timer.wait_time = interval
	timer.process_callback =Timer.TIMER_PROCESS_IDLE
	timer.timeout.connect(spawn_body)
	add_child(timer)
	timer.start()
	return next_scene_name

var count = 0

func spawn_body() -> void:
	if count > 5000:
		return
	var offset = (Global.WINDOW_SIZE.x + 200) / 19
	for i in range(20):
		var body = _get_rigid_body(TOP_LEFT + Vector2(500 + i * offset + randf(), -500))
		#var polygon := Polygon2D.new()
		#polygon.polygon = [Vector2(-5,-5),Vector2(-5,5),Vector2(5,5),Vector2(5,-5)]
		#body.add_child(polygon)
		add_child(body)
	count += 20
	
func _get_rigid_body(p_position: Vector2) -> RigidBody2D:
	var body = RigidBody2D.new()
	var shape = PhysicsTest2D.get_default_collision_shape(type, 1)
	body.add_child(shape)
	body.position = p_position
	return body
