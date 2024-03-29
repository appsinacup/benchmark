# Physics Engines Benchmark Scenes

In order to run the tests, simply go to the scene of the test you want to run, run it and it will generate the data needed to create the graphs.

If you want to change the physics engine, first you need to install a different one:
- [Godot Box2D 2.4.x](https://godotengine.org/asset-library/asset/2007)
- [Godot Rapier2D](https://godotengine.org/asset-library/asset/2267)

After installing, go to `Advanced Settings` -> `Physics` -> `2D`. Change Physics Engine to the one you want to test, eg.(Rapier2D or Box2D)

# Scenes

- tests/nodes/RigidBody/tests/2d/falling_circles.tscn
- tests/nodes/RigidBody/tests/2d/falling_rectangles.tscn
- tests/nodes/RigidBody/tests/2d/pyramid_pin_joint.tscn
- tests/nodes/RigidBody/tests/2d/rectangle_pyramid.tscn
- tests/nodes/RigidBody/tests/2d/rectangle_stack.tscn
