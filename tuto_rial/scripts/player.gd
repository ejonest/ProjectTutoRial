extends CharacterBody3D

@onready var visual : Node3D = $Armature

var SPEED = 5.0
const JUMP_VELOCITY = 4

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var lookat
var lastLookAtDirection : Vector3
func _ready():
	lookat = get_tree().get_nodes_in_group("CameraController")[0].get_node("LookAt")
	
#func _input(event):
	#if (event.is_pressed() && event.button_index == BUTTON_LEFT):
		#print("Mouse Click/Unclick at: ", event.position)
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	if (Input.is_action_pressed("sprint")):
		SPEED = 10
	else:
		SPEED = 5
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var lerpDirection = lerp(lastLookAtDirection, Vector3(lookat.global_position.x, global_position.y, lookat.global_position.z), .05)
		look_at(lerpDirection) 
		lastLookAtDirection = lerpDirection
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	#if velocity.length() > -.2:
		#var lookDir = Vector2(velocity.z, velocity.x)
		#visual.rotation.y = lookDir.angle()

	$AnimationTree.set("parameters/conditions/idle", input_dir == Vector2.ZERO && is_on_floor())
	$AnimationTree.set("parameters/conditions/walk", input_dir != Vector2.ZERO && is_on_floor())
	$AnimationTree.set("parameters/conditions/run", input_dir != Vector2.ZERO && is_on_floor() && Input.is_action_pressed("sprint"))
	$AnimationTree.set("parameters/conditions/thrillIt", Input.is_action_just_pressed("thriller"))
	$AnimationTree.set("parameters/conditions/jumpRun", !(is_on_floor()))
	$AnimationTree.set("parameters/conditions/punchLeft", input_dir == Vector2.ZERO && is_on_floor() && Input.is_action_just_pressed("BUTTON_LEFT"))
	move_and_slide()
