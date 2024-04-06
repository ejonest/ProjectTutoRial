extends CharacterBody3D


var SPEED = 5.0
const JUMP_VELOCITY = 4

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var lookat
var lastLookAtDirection : Vector3
var weaponOn = false
var weaponNode
var animate = false
func _ready():
	lookat = get_tree().get_nodes_in_group("CameraController")[0].get_node("LookAt")
	weaponNode = get_node("Armature/Skeleton3D/BoneAttachment3D/Sword")
	weaponNode.visible = false
	
#func _input(event):
	#if (event.is_pressed() && event.button_index == BUTTON_LEFT):
		#print("Mouse Click/Unclick at: ", event.position)
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		weaponNode.visible = false
		weaponOn = false
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
		var lerpDirection = lerp(lastLookAtDirection, Vector3(lookat.global_position.x, 
			global_position.y, lookat.global_position.z), .05)
		look_at(lerpDirection) 
		lastLookAtDirection = lerpDirection
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
# Toggle sword
	if Input.is_action_just_pressed("equip") and is_on_floor() and input_dir == Vector2.ZERO:
		animate = true
		await get_tree().create_timer(1).timeout
		weaponOn = !(weaponOn)

# Basic motion
	$AnimationTree.set("parameters/conditions/idle", input_dir == Vector2.ZERO && is_on_floor())
	$AnimationTree.set("parameters/conditions/walk", input_dir != Vector2.ZERO && is_on_floor())
	$AnimationTree.set("parameters/conditions/run", input_dir != Vector2.ZERO && is_on_floor() 
		&& Input.is_action_pressed("sprint"))
# emotes
	$AnimationTree.set("parameters/conditions/thrillIt", Input.is_action_just_pressed("thriller"))
# Jumping
	$AnimationTree.set("parameters/conditions/jumpRun", !(is_on_floor()))
	$AnimationTree.set("parameters/conditions/jumpStand", input_dir == Vector2.ZERO && is_on_floor()
		&& Input.is_action_just_pressed("ui_accept"))
# Toggle equip and attack
	$AnimationTree.set("parameters/conditions/SwordOff", animate && weaponOn)
	$AnimationTree.set("parameters/conditions/SwordOn", animate && !(weaponOn))
	$AnimationTree.set("parameters/conditions/punchLeft", input_dir == Vector2.ZERO && is_on_floor() 
		&& Input.is_action_just_pressed("BUTTON_LEFT") && !(weaponOn))
	$AnimationTree.set("parameters/conditions/slashSingle", input_dir == Vector2.ZERO 
		&& is_on_floor() && Input.is_action_just_pressed("BUTTON_LEFT") && weaponOn)
	animate = false
	weaponNode.visible = weaponOn
	
	move_and_slide()
