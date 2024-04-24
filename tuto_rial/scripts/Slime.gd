extends CharacterBody3D


const SPEED = 1.5
var player : Node3D
@onready var visual : Node3D = $Slime
#@onready var playerScript = load("res://scripts/TestTuto.gd").new()

#var direction: Vector3
var stopDistance : float = 1

var health = 20
var maxHealth = 20
var lookat
var lastLookAtDirection : Vector3
var takingDamage = false
var JUMP_VELOCITY = 5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumpCount = 0
var attackPossible = false
var knockback = 0
var currDistance
var move = false
var rng = RandomNumberGenerator.new()
var shouldLerp = true
var whereToGo

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	player.attack.connect(_on_test_tuto_attack)
	lookat = player.get_node("LookAt")
	$SubViewport/healthbar.value = health
	$SubViewport/healthbar.max_value = maxHealth

func _physics_process(delta):
	var input_dir
	var direction
	currDistance = distance(lookat.global_position, global_position)
	if move:
		look_at(Vector3(lookat.global_position.x, global_position.y, lookat.global_position.z))
	if currDistance < 12 && knockback == 0 && health > 0:
		move = true
	else:
		move = false
		#print("not moving")
	if knockback != 0:
		velocity.x = -whereToGo.x * SPEED * 2
		velocity.z = -whereToGo.z * SPEED * 2
	elif !move:
		velocity.x = 0
		velocity.z = 0
	else:
		whereToGo = Vector3((lookat.global_position.x - global_position.x), global_position.y,
			(lookat.global_position.z - global_position.z)).normalized()
		velocity.x = whereToGo.x * SPEED 
		velocity.z = whereToGo.z * SPEED
		
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	$AnimationTree.set("parameters/conditions/Idle", !move && !takingDamage && health > 0)
	$AnimationTree.set("parameters/conditions/Walk", move && !takingDamage && health > 0)
	$AnimationTree.set("parameters/conditions/Damage", takingDamage && health > 0)
	$AnimationTree.set("parameters/conditions/Death", health <= 0)
	takingDamage = false
	
	move_and_slide()
	
func distance(a, b):
	var dist = sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y) + 
					(a.z - b.z) * (a.z - b.z))
	return dist
	
func jump():
	if health > 0:
		velocity.y = 3
	
func hit(attackType):
	if attackType == 'sword':
		health -= 2;
		$SubViewport/healthbar.value -= 2;
	elif attackType == 'fist':
		health -= 1;
		$SubViewport/healthbar.value -= 1;
	else:
		push_error("Attack occured but it was not with sword or fist")
	takingDamage = true
	knockback = 2
	print(health)
	await get_tree().create_timer(.5).timeout
	knockback = 0

func setPos(x, y, z):
	global_position = Vector3(x, y, z)
	
func getHealth():
	return health

func _on_test_tuto_attack(attackType):
	if attackPossible:
		hit(attackType)
	
func _on_hitbox_area_entered(area):
	if area.is_in_group("Sword"):
		attackPossible = true
	#elif area.is_in_group("PlayerHitBox"):
		#knockback = 1

func _on_hitbox_area_exited(area):
	if area.is_in_group("Sword"):
		attackPossible = false
