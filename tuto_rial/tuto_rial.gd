extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var lookAt
var lastLookAtDirt : Vector3
var isJumping = false

func _ready():
	lookAt = get_tree().get_nodes_in_group("CameraController")[0].get_node("LookAt")



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# For always follow the player
	# look_at(Vector3(u_look_at.global_position.x, global_position.y, u_look_at.global_position.z))
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and Input.is_action_pressed("sprint"):
		var lerpDirection = lerp(lastLookAtDirt, Vector3(lookAt.global_position.x, global_position.y, lookAt.global_position.z), .05)
		look_at(lerpDirection)
		lastLookAtDirt = lerpDirection
		velocity.x = direction.x * SPEED * 2
		velocity.z = direction.z * SPEED * 2
	elif direction:
		var lerpDirection = lerp(lastLookAtDirt, Vector3(lookAt.global_position.x, global_position.y, lookAt.global_position.z), .05)
		look_at(lerpDirection)
		lastLookAtDirt = lerpDirection
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	$AnimationTree.set("parameters/conditions/idle", input_dir == Vector2.ZERO && is_on_floor())
	$AnimationTree.set("parameters/conditions/walk", input_dir != Vector2.ZERO && is_on_floor())
	
	move_and_slide()
