extends PhysicsUnitTest2D

var timer: Timer
var min_body_expected := 5000
@export var type:= TestCollisionShape.CIRCLE
var simulation_duration := 25
@export var interval := 0.05

var bodies : Array[RigidBody2D] = []

func test_description() -> String:
	return """In this benchmark, there are about X small cubes falling on a large cubic "cup" in a completely unordered way.
	"""
	
func test_name() -> String:
	return "Falling " + shape_name(type)

func test_start() -> void:
	add_collision_boundaries(20, false)

	timer = Timer.new()
	timer.wait_time = interval
	timer.process_callback =Timer.TIMER_PROCESS_PHYSICS
	timer.timeout.connect(spawn_body)
	add_child(timer)
	timer.start()

func write_line(line: String):
	var data_csv = FileAccess.open("user://data.csv", FileAccess.READ_WRITE)
	data_csv.seek_end()
	data_csv.store_line(line)
	print(line)

var count = 0

func spawn_body() -> void:
	if count > min_body_expected:
		get_tree().quit();
	write_line(str(count) + \
		"," + \
		str(Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)) + \
		"," + \
		str(Performance.get_monitor(Performance.PHYSICS_2D_ACTIVE_OBJECTS)))
	var offset = (Global.WINDOW_SIZE.x - 100) / 19
	for i in range(20):
		var body = _get_rigid_body(TOP_LEFT + Vector2(50 + i * offset + randf(), 0))
		#var polygon := Polygon2D.new()
		#polygon.polygon = [Vector2(-5,-5),Vector2(-5,5),Vector2(5,5),Vector2(5,-5)]
		#body.add_child(polygon)
		add_child(body)
	count += 20
	
func _get_rigid_body(p_position: Vector2) -> RigidBody2D:
	var body = RigidBody2D.new()
	var shape = PhysicsTest2D.get_default_collision_shape(type, 0.45)
	body.add_child(shape)
	body.position = p_position
	return body
