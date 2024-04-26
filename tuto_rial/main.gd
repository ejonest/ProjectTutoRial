extends Node

@onready var slimePlain = load("res://Enemies/slime.tscn")
@onready var slimeTeal = load("res://Enemies/slimeTeal.tscn")
@onready var slimeWhite = load("res://Enemies/slimeWhite.tscn")
@onready var slimeRock = load("res://Enemies/slimeRock.tscn")
var enemyArray : Array
var forestPortal
var errorPortal
var mazePortal
signal levelName
var player
var reloadingScene = false

func _ready():
# To spawn an enemy you need to pass it a location(vector3), a scaling(vector3), 
# health(int), speed(float), if they can take damage(bool), and the type of slime
	player = get_tree().get_nodes_in_group("Player")[0]
	spawnenemy(Vector3(-5, 1, -12), Vector3(5, 5, 5), 10, 1.5, true, slimePlain)
	spawnenemy(Vector3(5, 1, -12), Vector3(5, 5, 5), 10, 1.5, true, slimeTeal)
	spawnenemy(Vector3(-3, 5, -40), Vector3(5, 5, 5), 30, 1.5, true, slimeWhite)
	spawnenemy(Vector3(3, 5, -40), Vector3(5, 5, 5), 10, 1.5, true, slimeRock)
	forestPortal = get_tree().get_nodes_in_group("Portal")[0]
	forestPortal.changeScene.connect(ForestScene)
	errorPortal = get_tree().get_nodes_in_group("Portal")[1]
	errorPortal.changeScene.connect(ErrorScene)
	mazePortal = get_tree().get_nodes_in_group("Portal")[2]
	mazePortal.changeScene.connect(MazeScene)
	levelName.emit("res:://main.tscn")
	pass

func _process(delta):
	var i = 0
	if enemyArray.size() > 0:
		for n in enemyArray:
			if n.getHealth() <= 0:
				n.queue_free()
				enemyArray.pop_at(i)
			i += 1
	if player.playerHealth == 0:
		ReloadScene()
	pass

func ForestScene():
	print("exiting")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file.bind("res://Levels/ForestScene.tscn").call_deferred()
	print("should have exited")
	pass
	
func ErrorScene():
	print("exiting")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file.bind("res://Levels/error_world.tscn").call_deferred()
	print("should have exited")
	pass
	
func MazeScene():
	print("exiting")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file.bind("res://Levels/slime_maze.tscn").call_deferred()
	print("should have exited")
	pass
	
func ReloadScene():
	if !reloadingScene:
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
