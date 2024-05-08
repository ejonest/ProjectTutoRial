extends CharacterBody3D

var SPEED = 5.0
const JUMP_VELOCITY = 4.5
var crouching = false
var sword = false
var meleeOne = false
var weaponNode
@export var playerHealth = 100
@export var maxPlayerHealth = 100
var hitLeft = true
var lookat
var lastLookAtDirection : Vector3
#@onready var node_b = $Sword
var node_b
var beingTouched = false
var damageAni = false
var attacking = false
var moveOn = 1
var canHeal = true
var walkingOut = false
var walkAwayFrom
var walkDir = Vector3(0, 0, 0)
var toward

signal attack
signal healthChange

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	lookat = get_tree().get_nodes_in_group("CameraController")[0].get_node("LookAt")
	weaponNode = get_node("Armature/Skeleton3D/BoneAttachment3D/Sword")
	weaponNode.visible = false
	walkOut()

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
		SPEED = 8.0
		sword = false
		weaponNode.visible = false
	elif Input.is_action_just_released("sprint") && !crouching:
		SPEED = 5.0
	elif Input.is_action_just_pressed("crouch") && !crouching:
		crouching = true
		SPEED = 3.0
	elif Input.is_action_just_pressed("crouch") && crouching:
		crouching = false
		SPEED = 5.0
		
	if Input.is_action_just_pressed("equip"):
		sword = !sword
		weaponNode.visible = !weaponNode.visible
		
	if Input.is_action_just_pressed("heal"):
		heal()
	
	if Input.is_action_just_pressed("minus"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if Input.is_action_just_pressed("equal"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var input_dir = Vector2(0, 0)
	if Input.is_action_pressed("left"):
		input_dir.x += -1
	if Input.is_action_pressed("right"):
		input_dir.x += 1
	if Input.is_action_pressed("backward"):
		input_dir.y += 1
	if Input.is_action_pressed("forward"):
		input_dir.y += -1
	if moveOn == 0:
		input_dir = Vector2(0, 0)
		
	if walkingOut:
		walkAwayFrom = get_tree().get_nodes_in_group("Entrance")[0]
		if walkDir == Vector3(0, 0, 0):
			toward = walkAwayFrom.get_node("ForVec").global_position
			walkDir = toward - global_position
		#print("I should be walking")
		#velocity.z = global_position.z - walkAwayFrom.position.z * SPEED
		velocity.z = walkDir.z
		velocity.x = walkDir.x
		#print(velocity)
		#global_position.z -= (walkAwayFrom.position.z - global_position.z) / 50
		#print(global_position.z)
		#print(velocity.z)
		#walkAwayFrom.z
		
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var lerpDirection = lerp(Vector3(lastLookAtDirection.x, global_position.y, 
			lastLookAtDirection.z), Vector3(lookat.global_position.x, global_position.y, 
			lookat.global_position.z), .05)
		if moveOn == 1:
			look_at(lerpDirection)
			pass
		lastLookAtDirection = lerpDirection
		velocity.x = direction.x * SPEED * moveOn
		velocity.z = direction.z * SPEED * moveOn
	else:
		#velocity.x = move_toward(velocity.x, 0, SPEED) * moveOn
		#velocity.z = move_toward(velocity.z, 0, SPEED) * moveOn
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
#IDLE
	$AnimationTree.set("parameters/conditions/idle", input_dir == Vector2.ZERO && is_on_floor() 
		&& !crouching && !walkingOut)
#WALK
	#$AnimationTree.set("parameters/conditions/walk", walkingOut == true)
	$AnimationTree.set("parameters/conditions/walk", walkingOut || input_dir.x == 0 && input_dir.y == -1 
		&& is_on_floor() && SPEED == 5.0 && !crouching && moveOn != 0)
	$AnimationTree.set("parameters/conditions/back", input_dir.x == 0 && input_dir.y == 1 
		&& is_on_floor() && SPEED == 5.0 && !crouching && moveOn != 0)
	$AnimationTree.set("parameters/conditions/left", input_dir.x == -1 && is_on_floor()
		&& SPEED == 5.0 && !crouching && moveOn != 0)
	$AnimationTree.set("parameters/conditions/right", input_dir.x == 1 && is_on_floor()
		&& SPEED == 5.0 && !crouching && moveOn != 0)
#SPRINT
	$AnimationTree.set("parameters/conditions/sprint", input_dir.x == 0 && input_dir.y == -1 
		&& is_on_floor() && SPEED == 8.0 && moveOn != 0)
	$AnimationTree.set("parameters/conditions/sprintBack", input_dir.x == 0 && input_dir.y == 1 
		&& is_on_floor() && SPEED == 8.0 && moveOn != 0)
	$AnimationTree.set("parameters/conditions/sprintLeft", input_dir.x == -1 && is_on_floor() 
		&& SPEED == 8.0 && moveOn != 0)
	$AnimationTree.set("parameters/conditions/sprintRight", input_dir.x == 1 && is_on_floor()
		&& SPEED == 8.0 && moveOn != 0)
#JUMP
	$AnimationTree.set("parameters/conditions/jump", Input.is_action_pressed("jump") && moveOn != 0)
#CROUCH IDLE
	$AnimationTree.set("parameters/conditions/crouch", input_dir == Vector2.ZERO && is_on_floor() 
		&& crouching && moveOn != 0)
#CROUCH WALK
	$AnimationTree.set("parameters/conditions/crouchWalk", input_dir.x == 0 && input_dir.y == -1 
		&& is_on_floor() && crouching && moveOn != 0)
	$AnimationTree.set("parameters/conditions/crouchBack", input_dir.x == 0 && input_dir.y == 1 
		&& is_on_floor() && crouching && moveOn != 0)
	$AnimationTree.set("parameters/conditions/crouchLeft", input_dir.x == -1 && is_on_floor()
		&& crouching && moveOn != 0)
	$AnimationTree.set("parameters/conditions/crouchRight", input_dir.x == 1 && is_on_floor()
		&& crouching && moveOn != 0)
#Equip
	$AnimationTree.set("parameters/conditions/equip", input_dir == Vector2.ZERO 
		&& is_on_floor() && !crouching && !sword && Input.is_action_pressed("equip") && moveOn != 0)
	$AnimationTree.set("parameters/conditions/unequip", input_dir == Vector2.ZERO 
		&& is_on_floor() && !crouching && sword && Input.is_action_pressed("equip") && moveOn != 0)
#Combat
	$AnimationTree.set("parameters/conditions/punchLeft", input_dir == Vector2.ZERO 
		&& is_on_floor() && !crouching && !sword && meleeOne 
		&& Input.is_action_pressed("attack") && moveOn != 0)
	$AnimationTree.set("parameters/conditions/punchRight", input_dir == Vector2.ZERO 
		&& is_on_floor() && !crouching && !sword && !meleeOne
		&& Input.is_action_pressed("attack") && moveOn != 0)
	$AnimationTree.set("parameters/conditions/slashUnder", input_dir == Vector2.ZERO 
		&& is_on_floor() && !crouching && sword && meleeOne 
		&& Input.is_action_pressed("attack") && moveOn != 0)
	$AnimationTree.set("parameters/conditions/slashOver", input_dir == Vector2.ZERO 
		&& is_on_floor() && !crouching && sword && !meleeOne
		&& Input.is_action_pressed("attack") && moveOn != 0)
	$AnimationTree.set("parameters/conditions/slashOver", input_dir == Vector2.ZERO 
		&& is_on_floor() && !crouching && sword && !meleeOne
		&& Input.is_action_pressed("attack") && moveOn != 0)
# DAMAGE
	$AnimationTree.set("parameters/conditions/hitLeft", damageAni && hitLeft 
		&& playerHealth > 0)
	$AnimationTree.set("parameters/conditions/hitRight", damageAni && !hitLeft 
		&& playerHealth > 0)
# DEATH
	$AnimationTree.set("parameters/conditions/death", playerHealth <= 0)
	#print(playerHealth)
	move_and_slide()

func walkOut():
	moveOn = 0
	await get_tree().create_timer(.5).timeout
	walkingOut = true
	#print("Walking out now: ", walkingOut)
	await get_tree().create_timer(1.5).timeout
	walkingOut = false
	moveOn = 1
	#print("Man that was a long walk: ", walkingOut)
	
func heal():
	if canHeal:
		canHeal = false
		playerHealth += 10
		healthChange.emit()
		await get_tree().create_timer(10.0).timeout
		canHeal = true
	
func hit():
	hitLeft = !hitLeft
	print(playerHealth)
	if playerHealth > 0:
		playerHealth -= 10
		healthChange.emit()
	damageAni = true
	await get_tree().create_timer(1.0).timeout
	damageAni = false

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	
func attackNow():
	attacking = true
	if sword:
		emit_signal("attack", 'sword')
	else:
		emit_signal("attack", 'fist')
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
		
func _swordChange():
	pass
