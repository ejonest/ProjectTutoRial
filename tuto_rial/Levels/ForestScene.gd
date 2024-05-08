extends Node

@onready var slimeTeal = load("res://Enemies/slimeTeal.tscn")
@onready var portalEnt = load("res://Asset/Environment/Scene/treePortal.tscn")
var objLabel 
var warningLabel
var enemyArray : Array
var exitPortal
var canFlipLights = true
var slimesHaveSpawned = false
var player
var reloadingScene = false
var paused = false
var shrink = false
var shrinkJ = 1
var entranceExists = true
var entrance

const EYE = preload("res://cosmiceye_ready.png")
const NOEYE = preload("res://cosmiceye_unready.png")

func _ready():
	entrance = portalEnt.instantiate()
	entrance.position = Vector3(-22, 28, -52)
	#entrance.rotate(Vector3(0, 1, 0), 3.14)
	add_child(entrance)
	spawnEnt()
	player = get_tree().get_nodes_in_group("Player")[0]
	spawnenemy(Vector3(-24, 29.5, -20), Vector3(3, 3, 3), 10, 3, true, slimeTeal)
	spawnenemy(Vector3(-18, 29.5, -5), Vector3(2, 2, 2), 6, 3, true, slimeTeal)
	spawnenemy(Vector3(-18, 29.5, 14), Vector3(2, 2, 2), 6, 3, true, slimeTeal)
	spawnenemy(Vector3(38, 29.5, -20), Vector3(4, 4, 4), 50, 4, true, slimeTeal)
	exitPortal = get_tree().get_nodes_in_group("Portal")[0]
	exitPortal.changeScene.connect(ReturnHome)
	for n in get_tree().get_nodes_in_group("Lights"):
				n.visible = false
	Engine.time_scale = 1
	objLabel = get_tree().get_nodes_in_group("Objective")[0]
	warningLabel = get_tree().get_nodes_in_group("Warning")[0]
	pass

func _process(delta):
	var i = 0
	for n in enemyArray:
		if n.getHealth() <= 0:
			n.queue_free()
			enemyArray.pop_at(i)
		i += 1
	if player.playerHealth == 0:
		ReloadScene()
		
	if Input.is_action_just_pressed("esc"):
		pauseMenu()
	if shrink && entranceExists:
		entrance.scale = Vector3(1, shrinkJ, shrinkJ)
		shrinkJ -= .01
		
	if canFlipLights == true:
		%EyeAbility.texture = EYE
	else:
		%EyeAbility.texture = NOEYE
	
func spawnEnt():
	await get_tree().create_timer(2).timeout
	shrink = true
	await get_tree().create_timer(4).timeout
	entranceExists = false
	print("test")
	entrance.queue_free()
	print("Should be gone now")

func ReloadScene():
	if !reloadingScene:
		player.moveOn = 0
		reloadingScene = true
		print("reloading")
		await get_tree().create_timer(5).timeout
		get_tree().change_scene_to_file.bind("res://Levels/ForestScene.tscn").call_deferred()
		pass
		
func ReturnHome():
	if enemyArray.size() == 0:
		player.moveOn = 0
		print("exiting")
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file.bind("res://main.tscn").call_deferred()
		print("should have exited")
		pass
	else:
		warningLabel.text = "YOU MUST DEFEAT ALL THE SLIMES TO EXIT"
		await get_tree().create_timer(3).timeout
		warningLabel.text = ""
	
func spawnenemy(pos : Vector3, scale : Vector3, health : int, speed : float, canTakeDamage : bool, Type):
	var enemy = Type.instantiate()
	enemy.position = pos
	enemy.scale = scale
	enemy.setHealth(health)
	enemy.setSpeed(speed)
	enemy.takeDamage(canTakeDamage)
	add_child(enemy)
	var children = get_children()
	#print("Size A: ", enemyArray.size())
	enemyArray.append(enemy)
	#print("Size B: ", enemyArray.size())
	pass

func removeenemy():
	#if enemy:
		#enemy.queue_free()
	#spawnenemy()
	pass

func _on_drop_slimes_area_entered(area):
	if area.is_in_group("LeftHand") || area.is_in_group("RightHand"):
		if !slimesHaveSpawned:
			spawnenemy(Vector3(37, 29, -4), Vector3(2, 2, 2), 20, 10, true, slimeTeal)
			spawnenemy(Vector3(33, 29, -7), Vector3(2, 2, 2), 20, 10, true, slimeTeal)
			slimesHaveSpawned = true

func pauseMenu():
	if paused:
		$CameraController/SpringArm3D/Camera3D/PauseMenu.hide()
		Engine.time_scale = 1
	else:
		$CameraController/SpringArm3D/Camera3D/PauseMenu.show()
		Engine.time_scale = 0
		
	paused = !paused
