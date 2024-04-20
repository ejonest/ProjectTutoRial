extends CharacterBody3D


var SPEED = 5.0
const JUMP_VELOCITY = 4.5
var crouching = false
var sword = false
var meleeOne = false
var weaponNode
var playerHealth = 100
var hitLeft = true
var lookat
var lastLookAtDirection : Vector3
#@onready var node_b = $Sword
var node_b
var beingTouched = false
var damageAni = false
var attacking = false
var moveOn = 1

signal attack

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	lookat = get_tree().get_nodes_in_group("CameraController")[0].get_node("LookAt")
	weaponNode = get_node("Armature/Skeleton3D/BoneAttachment3D/Sword")
	weaponNode.visible = false

func _physics_process(delta):
	if playerHealth <= 0:
		moveOn = 0
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !crouching:
		velocity.y = JUMP_VELOCITY
		sword = false
		weaponNode.visible = false
	# Handle the sprint/crouch/walk speed (10, 3, 5) respectivly 
	if Input.is_action_pressed("sprint") && !crouching:
		SPEED = 10.0
		sword = false
		weaponNode.visible = false
	elif Input.is_action_just_pressed("crouch") && !crouching:
		crouching = true
		SPEED = 3.0
	elif Input.is_action_just_pressed("crouch") && crouching:
		crouching = false
		SPEED = 5.0
		
	if Input.is_action_just_pressed("equip"):
		sword = !sword
		weaponNode.visible = !weaponNode.visible
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var lerpDirection = lerp(lastLookAtDirection, Vector3(lookat.global_position.x, 
			global_position.y, lookat.global_position.z), .05)
		if moveOn == 1:
			look_at(lerpDirection)
		lastLookAtDirection = lerpDirection
		velocity.x = direction.x * SPEED * moveOn
		velocity.z = direction.z * SPEED * moveOn
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) * moveOn
		velocity.z = move_toward(velocity.z, 0, SPEED) * moveOn
#IDLE
	$AnimationTree.set("parameters/conditions/idle", input_dir == Vector2.ZERO && is_on_floor() 
		&& !crouching)
#WALK
	$AnimationTree.set("parameters/conditions/walk", input_dir.x == 0 && input_dir.y == -1 
		&& is_on_floor() && SPEED == 5.0 && !crouching)
	$AnimationTree.set("parameters/conditions/back", input_dir.x == 0 && input_dir.y == 1 
		&& is_on_floor() && SPEED == 5.0 && !crouching)
	$AnimationTree.set("parameters/conditions/left", input_dir.x == -1 && is_on_floor()
		&& SPEED == 5.0 && !crouching)
	$AnimationTree.set("parameters/conditions/right", input_dir.x == 1 && is_on_floor()
		&& SPEED == 5.0 && !crouching)
#SPRINT
	$AnimationTree.set("parameters/conditions/sprint", input_dir.x == 0 && input_dir.y == -1 
		&& is_on_floor() && SPEED == 10.0)
	$AnimationTree.set("parameters/conditions/sprintBack", input_dir.x == 0 && input_dir.y == 1 
		&& is_on_floor() && SPEED == 10.0)
	$AnimationTree.set("parameters/conditions/sprintLeft", input_dir.x == -1 && is_on_floor() 
		&& SPEED == 10.0)
	$AnimationTree.set("parameters/conditions/sprintRight", input_dir.x == 1 && is_on_floor()
		&& SPEED == 10.0)
#JUMP
	$AnimationTree.set("parameters/conditions/jump", Input.is_action_pressed("jump"))
#CROUCH IDLE
	$AnimationTree.set("parameters/conditions/crouch", input_dir == Vector2.ZERO && is_on_floor() 
		&& crouching)
#CROUCH WALK
	$AnimationTree.set("parameters/conditions/crouchWalk", input_dir.x == 0 && input_dir.y == -1 
		&& is_on_floor() && crouching)
	$AnimationTree.set("parameters/conditions/crouchBack", input_dir.x == 0 && input_dir.y == 1 
		&& is_on_floor() && crouching)
	$AnimationTree.set("parameters/conditions/crouchLeft", input_dir.x == -1 && is_on_floor()
		&& crouching)
	$AnimationTree.set("parameters/conditions/crouchRight", input_dir.x == 1 && is_on_floor()
		&& crouching)
#Equip
	$AnimationTree.set("parameters/conditions/equip", input_dir == Vector2.ZERO 
		&& is_on_floor() && !crouching && !sword && Input.is_action_pressed("equip"))
	$AnimationTree.set("parameters/conditions/unequip", input_dir == Vector2.ZERO 
		&& is_on_floor() && !crouching && sword && Input.is_action_pressed("equip"))
#Combat
	$AnimationTree.set("parameters/conditions/punchLeft", input_dir == Vector2.ZERO 
		&& is_on_floor() && !crouching && !sword && meleeOne 
		&& Input.is_action_pressed("attack"))
	$AnimationTree.set("parameters/conditions/punchRight", input_dir == Vector2.ZERO 
		&& is_on_floor() && !crouching && !sword && !meleeOne
		&& Input.is_action_pressed("attack"))
	$AnimationTree.set("parameters/conditions/slashUnder", input_dir == Vector2.ZERO 
		&& is_on_floor() && !crouching && sword && meleeOne 
		&& Input.is_action_pressed("attack"))
	$AnimationTree.set("parameters/conditions/slashOver", input_dir == Vector2.ZERO 
		&& is_on_floor() && !crouching && sword && !meleeOne
		&& Input.is_action_pressed("attack"))
	$AnimationTree.set("parameters/conditions/slashOver", input_dir == Vector2.ZERO 
		&& is_on_floor() && !crouching && sword && !meleeOne
		&& Input.is_action_pressed("attack"))
# DAMAGE
	$AnimationTree.set("parameters/conditions/hitLeft", damageAni && hitLeft 
		&& playerHealth > 0)
	$AnimationTree.set("parameters/conditions/hitRight", damageAni && !hitLeft 
		&& playerHealth > 0)
# DEATH
	$AnimationTree.set("parameters/conditions/death", playerHealth <= 0)
	#print(playerHealth)
	move_and_slide()

func hit():
	hitLeft = !hitLeft
	print(playerHealth)
	if playerHealth > 0:
		playerHealth -= 10
	damageAni = true
	await get_tree().create_timer(1.0).timeout
	damageAni = false

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	
func attackNow():
	attacking = true
	emit_signal("attack")
	await get_tree().create_timer(.5).timeout
	attacking = false
	
func attackChange():
	pass

func _on_hitbox_area_entered(area):
	if area.is_in_group("Enemy"):
		beingTouched = true
		if !attacking:
			while beingTouched:
				hit()
				await get_tree().create_timer(1.5).timeout
	#print(beingTouched)
	pass

func _on_hitbox_area_exited(area):
	if area.is_in_group("Enemy"):
		beingTouched = false
		#print(beingTouched)
