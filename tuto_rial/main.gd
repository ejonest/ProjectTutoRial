extends Node

@onready var slimePlain = load("res://Enemies/slime.tscn")
@onready var slimeTeal = load("res://Enemies/slimeTeal.tscn")
@onready var slimeWhite = load("res://Enemies/slimeWhite.tscn")
@onready var slimeRock = load("res://Enemies/slimeRock.tscn")
@onready var portalEnt = load("res://Asset/Environment/Scene/portalEnt.tscn")
var paused = false
var enemyArray : Array
var forestPortal
var errorPortal
var mazePortal
signal levelName
var player
var reloadingScene = false
var spawnArray : Array
var k = 0
var shrink = false
var shrinkJ = 1
var entranceExists = true
var entrance
var OnScreenText
var WelcomeText
var canFlipLights = true
var EnemyText = ["Before you is the plain slime. They tend to have a moderate health level and speed",
				 "This is the water slime. Doesn't take much to kill them but they are fast buggers",
				 "Here is the rock slime. These guys have the health of a tank but the speed of a sloth",
				 "Beware of the ghost slime. They are cursed to roam this world for all eternity"]

const EYE = preload("res://cosmiceye_ready.png")
const NOEYE = preload("res://cosmiceye_unready.png")

func _ready():
# To spawn an enemy you need to pass it a location(vector3), a scaling(vector3), 
# health(int), speed(float), if they can take damage(bool), and the type of slime
	get_node("Arrrow").visible = false
	entrance = portalEnt.instantiate()
	entrance.position = Vector3(1.52, 0, 3)
	entrance.rotate(Vector3(0, 1, 0), 3.14)
	add_child(entrance)
	spawnEnt()
	player = get_tree().get_nodes_in_group("Player")[0]
	spawnArray = [Vector3(-6, 1, -16), Vector3(5, 5, 5), 10, 3, true, slimePlain, 
		Vector3(5, 1, -12), Vector3(3, 3, 3), 6, 5, true, slimeTeal, 
		Vector3(3, 5, -40), Vector3(3, 3, 3), 30, 1.5, true, slimeRock,
		Vector3(-3, 5, -40), Vector3(3, 3, 3), 10, 3, false, slimeWhite]
	spawnenemy(spawnArray[k+0], spawnArray[k+1], spawnArray[k+2], spawnArray[k+3], spawnArray[k+4], spawnArray[k+5])
	k += 6
	forestPortal = get_tree().get_nodes_in_group("Portal")[0]
	forestPortal.changeScene.connect(ForestScene)
	errorPortal = get_tree().get_nodes_in_group("Portal")[1]
	errorPortal.changeScene.connect(ErrorScene)
	mazePortal = get_tree().get_nodes_in_group("Portal")[2]
	mazePortal.changeScene.connect(MazeScene)
	levelName.emit("res:://main.tscn")
	Engine.time_scale = 1
	WelcomeText = get_tree().get_nodes_in_group("Welcome")[0]
	WelcomeText.visible = true
	OnScreenText = get_tree().get_nodes_in_group("Info")[0]
	ChangeText()
	pass

func _process(delta):
	var i = 0
	if enemyArray.size() > 0:
		for n in enemyArray:
			if n.getHealth() <= 0:
				n.queue_free()
				enemyArray.pop_at(i)
			i += 1

	if enemyArray.size() == 0 && k < 19:
		spawnenemy(spawnArray[k+0], spawnArray[k+1], spawnArray[k+2], spawnArray[k+3], spawnArray[k+4], spawnArray[k+5])
		OnScreenText.text = EnemyText[k/6]
		k += 6

	if enemyArray.size() < 0:
		print("ERROR: There is less than zero enemies")

	if player.playerHealth == 0:
		ReloadScene()
	
	if Input.is_action_just_pressed("path") && canFlipLights:
		flipLights()
	if Input.is_action_just_pressed("esc"):
		pauseMenu()
	if shrink && entranceExists:
		entrance.scale = Vector3(1, shrinkJ, 1)
		shrinkJ -= .01
		
	if canFlipLights == true:
		%EyeAbility.texture = EYE
	else:
		%EyeAbility.texture = NOEYE

func flipLights():
	canFlipLights = false
	get_node("Arrrow").visible = true
	await get_tree().create_timer(2).timeout
	get_node("Arrrow").visible = false
	print("waiting")
	await get_tree().create_timer(10).timeout
	print("Done waiting")
	canFlipLights = true
	
func ChangeText():
	await get_tree().create_timer(4).timeout
	WelcomeText.visible = false
	OnScreenText.text = "If you are ever lost in a level try pressing F to locate the exit"
	await get_tree().create_timer(3).timeout
	OnScreenText.text = EnemyText[0]
	pass
func spawnEnt():
	await get_tree().create_timer(2).timeout
	shrink = true
	await get_tree().create_timer(4).timeout
	entranceExists = false
	print("test")
	entrance.queue_free()
	print("Should be gone now")

func ForestScene():
	player.moveOn = 0
	print("exiting")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file.bind("res://Levels/ForestScene.tscn").call_deferred()
	print("should have exited")
	pass
	
func ErrorScene():
	player.moveOn = 0
	print("exiting")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file.bind("res://Levels/error_world.tscn").call_deferred()
	print("should have exited")
	pass
	
func MazeScene():
	player.moveOn = 0
	print("exiting")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file.bind("res://Levels/slime_maze.tscn").call_deferred()
	print("should have exited")
	pass
	
func ReloadScene():
	if !reloadingScene:
		player.moveOn = 0
		reloadingScene = true
		print("reloading")
		await get_tree().create_timer(5).timeout
		get_tree().change_scene_to_file.bind("res://main.tscn").call_deferred()
		pass
	
func spawnenemy(pos : Vector3, scale : Vector3, health : int, speed : float, canTakeDamage : bool, Type):
	var enemy = Type.instantiate()
	enemy.position = pos
	enemy.scale = scale
	enemy.setHealth(health)
	enemy.setSpeed(speed)
	enemy.takeDamage(canTakeDamage)
	add_child(enemy)
	var children = get_children()
	enemyArray.append(enemy)
	#print("Size A: ", enemyArray.size())
	#for n in children:
		#if n.is_in_group("Enemy"):
			#enemyArray.append(n)
	#print("Size B: ", enemyArray.size())
	pass

func removeenemy():
	#if enemy:
		#enemy.queue_free()
	#spawnenemy()
	pass
	
func pauseMenu():
	if paused:
		$CameraController/SpringArm3D/Camera3D/PauseMenu.hide()
		Engine.time_scale = 1
	else:
		$CameraController/SpringArm3D/Camera3D/PauseMenu.show()
		Engine.time_scale = 0
		
	paused = !paused


func _on_portal_area_ent_area_entered(area):
	if area.is_in_group("LeftHand") || area.is_in_group("RightHand"):
		OnScreenText.text = "This is the level selection area. Pick a portal"
