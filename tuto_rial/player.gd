extends CharacterBody3D

@export var speed = 10
@export var jump_strength = 5

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var camera_x = %player_camera.get_global_transform().basis.x
	var camera_z = %player_camera.get_global_transform().basis.z
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("right"):
		direction += camera_x
		
	if Input.is_action_pressed("left"):
		direction -= camera_x 
		
	if Input.is_action_pressed("forward"):
		direction -= camera_z
		
	if Input.is_action_pressed("back"):
		direction += camera_z 
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if Input.is_action_pressed("sprint"):
		target_velocity.x = direction.x * (speed * 2)
		target_velocity.z = direction.z * (speed * 2)	
		
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (2 * jump_strength * delta)	
		
	if is_on_floor() and Input.is_action_pressed("jump"):
		target_velocity.y = jump_strength	
		
	velocity = target_velocity
	move_and_slide()
