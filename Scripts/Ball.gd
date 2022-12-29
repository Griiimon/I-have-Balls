extends RigidBody


export(float) var rolling_force= 1
export(float) var camera_distance= 10
export(float) var camera_up= 3
export(float) var mouse_rotation_speed= 0.05


var camera_rotation= 0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	var tmp= Vector3.ZERO
	if Input.is_action_pressed("forward"):
		tmp.x -= rolling_force*delta
	elif Input.is_action_pressed("back"):
		tmp.x += rolling_force*delta
	if Input.is_action_pressed("left"):
		tmp.z += rolling_force*delta
	elif Input.is_action_pressed("right"):
		tmp.z -= rolling_force*delta

	var camera_target_pos: Vector3= get_pos() - Vector3.BACK.rotated(Vector3.UP, camera_rotation) * camera_distance + Vector3.UP * camera_up
	
	var raycast_result= get_world().direct_space_state.intersect_ray(get_pos(), camera_target_pos)
	
	if raycast_result:
		camera_target_pos= raycast_result.position
	
	Globals.camera.global_transform.origin= camera_target_pos
	Globals.camera.look_at(global_transform.origin, Vector3.UP)

	add_torque(tmp.rotated(Vector3.UP, Globals.camera.rotation.y))



func get_pos()-> Vector3:
	return global_transform.origin


func _input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera_rotation= wrapf(camera_rotation - event.relative.x * mouse_rotation_speed, -PI, PI)

