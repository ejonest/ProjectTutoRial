extends Node

@onready var slimePlain = load("res://Enemies/slime.tscn")
@onready var slimeTeal = load("res://Enemies/slimeTeal.tscn")
@onready var slimeWhite = load("res://Enemies/slimeWhite.tscn")
@onready var slimeRock = load("res://Enemies/slimeRock.tscn")
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

func _ready():
# To spawn an enemy you need to pass it a location(vector3), a scaling(vector3), 
# health(int), speed(float), if they can take damage(bool), and the type of slime
	player = get_tree().get_nodes_in_group("Player")[0]
	spawnArray = [Vector3(-5, 1, -12), Vector3(5, 5, 5), 10, 1.5, true, slimePlain, 
		Vector3(5, 1, -12), Vector3(5, 5, 5), 10, 1.5, true, slimeTeal, 
		Vector3(3, 5, -40), Vector3(5, 5, 5), 10, 1.5, true, slimeRock,
		Vector3(-3, 5, -40), Vector3(5, 5, 5), 30, 1.5, false, slimeWhite]
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
		k += 6

	if enemyArray.size() < 0:
		print("ERROR: There is less than zero enemies")

	if player.playerHealth == 0:
		ReloadScene()

	if Input.is_action_just_pressed("esc"):
		pauseMenu()
		
	pass

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
