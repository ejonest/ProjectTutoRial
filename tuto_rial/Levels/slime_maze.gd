extends Node3D

@onready var slimePlain = load("res://Enemies/slime.tscn")
@onready var slimeTeal = load("res://Enemies/slimeTeal.tscn")
@onready var slimeWhite = load("res://Enemies/slimeWhite.tscn")
@onready var slimeRock = load("res://Enemies/slimeRock.tscn")

@onready var wall = load("res://Asset/Environment/Scene/wallDoor.tscn")
@onready var gate = load("res://Asset/Environment/Scene/Exit_Gate.tscn")
@onready var key = load("res://Asset/Environment/Scene/key.tscn")

var simultaneous_scene = preload("res://main.tscn").instantiate()
var enemyArray : Array
var doorArray : Array
var exitArray : Array
var keyNode
var gotKey = false
var hasEnemies = 0
var slime1Spawned = false
var slime2Spawned = false
var slime3Spawned = false
var slime4Spawned = false
var slime5Spawned = false
var slime7Spawned = false
var slime8Spawned = false
var destoryable = false
var j = 2
var Exit_Gate
var slowExit = false
var exitAngle = 0
var gotPos = false
var pos : Vector3
var pickedUpKey = false
var portalExt
var player
var reloadingScene = false

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	var exitGate = gate.instantiate()
	exitGate.position = Vector3(-2.73, 0, -85.5)
	add_child(exitGate)
	var children = get_children()
	for n in children:
		if n.is_in_group("ExitGate"):
			exitArray.append(n)
	exitArray[0].MayOpen.connect(openExit)
	keyNode = key.instantiate()
	keyNode.position = Vector3(-1.5, .585, -67)
	add_child(keyNode)
	keyNode.PickUp.connect(pickUp)
	print(keyNode.position)
	portalExt = get_tree().get_nodes_in_group("Portal")[1]
	portalExt.changeScene.connect(exitScene)
	pass

func _process(delta):
	var i = 0
	for n in enemyArray:
		if n.getHealth() <= 0:
			destoryEnemy()
			n.scale = Vector3(j, j, j)
			j -= .01
			if destoryable:
				n.queue_free()
				enemyArray.pop_at(i)
				destoryable = false
				j = 2
		i += 1
	i = 0
	if doorArray.size() > 0 && enemyArray.size() == 0:
		for n in doorArray:
			print("Size of doorArray: ", doorArray.size())
			n.queue_free()
			doorArray.pop_at(i)
			i += 1
		if slime5Spawned:
			gotKey = true
	if slowExit && exitAngle <= 3.14/2:
		exitAngle += 3.14/2/100
		exitArray[0].rotation = Vector3(0, exitAngle, 0)
	if player.playerHealth == 0:
		ReloadScene()
	pass

func ReloadScene():
	if !reloadingScene:
		player.moveOn = 0
		reloadingScene = true
		print("reloading")
		await get_tree().create_timer(5).timeout
		get_tree().change_scene_to_file.bind("res://Levels/slime_maze.tscn").call_deferred()
		pass
		
func destoryEnemy():
	await get_tree().create_timer(1.52).timeout
	destoryable = true
	pass

func pickUp():
	print("You picked up the key")
	keyNode.queue_free()
	keyNode = null
	pass
	
func exitScene():
	player.moveOn = 0
	print("exiting")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file.bind("res://main.tscn").call_deferred()
	print("should have exited")
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
	print("Size A: ", enemyArray.size())
	for n in children:
		if n.is_in_group("Enemy"):
			enemyArray.append(n)
	print("Size B: ", enemyArray.size())
	pass

func openExit():
	if gotKey:
		print("Opening Gate")
		#exitArray[0].rotation = Vector3(0, 3.14/2, 0)
		slowExit = true
	else:
		print("Can not open gate. You need a key")
	pass
	
#Slime Encounter Areas
func _on_slime_area_1_area_entered(area):
	if area.is_in_group("LeftHand") && !slime1Spawned:
		var wallDoor = wall.instantiate()
		wallDoor.position = Vector3(-11.5, .585, -14)
		wallDoor.rotation = Vector3(0, -3.14 / 2, 0)
		add_child(wallDoor)
		spawnenemy(Vector3(-21.5, 3, -19), Vector3(2, 2, 2), 30, 1.5, true, slimeRock)
		var children = get_children()
		for n in children:
			if n.is_in_group("Doors"):
				doorArray.append(n)
		slime1Spawned = true

func _on_slime_area_2_area_entered(area):
	if area.is_in_group("LeftHand") && !slime2Spawned:
		var wallDoor = wall.instantiate()
		wallDoor.position = Vector3(28, .585, -26)
		wallDoor.scale = Vector3(4, .75, 1)
		add_child(wallDoor)
		spawnenemy(Vector3(18.5, 3, -36), Vector3(2, 2, 2), 30, 1.5, true, slimeRock)
		var children = get_children()
		for n in children:
			if n.is_in_group("Doors"):
				doorArray.append(n)
		slime2Spawned = true

func _on_slime_area_3_area_entered(area):
	if area.is_in_group("LeftHand") && !slime3Spawned:
		var wallDoor = wall.instantiate()
		wallDoor.position = Vector3(-20, .585, -50)
		add_child(wallDoor)
		spawnenemy(Vector3(-22, 3, -44), Vector3(2, 2, 2), 30, 1.5, true, slimeRock)
		var children = get_children()
		for n in children:
			if n.is_in_group("Doors"):
				doorArray.append(n)
		slime3Spawned = true

func _on_slime_area_4_area_entered(area):
	if area.is_in_group("LeftHand") && gotKey && !slime4Spawned:
		var wallDoor = wall.instantiate()
		wallDoor.position = Vector3(8, .585, -54)
		add_child(wallDoor)
		spawnenemy(Vector3(14, 3, -48), Vector3(2, 2, 2), 30, 1.5, true, slimeRock)
		wallDoor = wall.instantiate()
		wallDoor.position = Vector3(24, .585, -54)
		add_child(wallDoor)
		var children = get_children()
		for n in children:
			if n.is_in_group("Doors"):
				doorArray.append(n)
		slime4Spawned = true

func _on_slime_area_5_area_entered(area):
	if area.is_in_group("LeftHand") && !gotKey && !slime5Spawned:
		#gotKey = true
		var wallDoor = wall.instantiate()
		wallDoor.position = Vector3(20.5, .585, -62)
		wallDoor.rotation = Vector3(0, 3*3.14/2, 0)
		add_child(wallDoor)
		spawnenemy(Vector3(-1.5, 3, -67), Vector3(2, 2, 2), 30, 1.5, true, slimeRock)
		var children = get_children()
		for n in children:
			if n.is_in_group("Doors"):
				doorArray.append(n)
		slime5Spawned = true
		#await get_tree().create_timer(2).timeout
		#var i = 0
		#for n in doorArray:
			#n.queue_free()
			#doorArray.pop_at(i)
			#i += 1

func _on_slime_area_6_area_entered(area):
	if area.is_in_group("LeftHand") && gotKey && !slime5Spawned:
		#gotKey = true
		var wallDoor = wall.instantiate()
		wallDoor.position = Vector3(20.5, .585, -62)
		wallDoor.rotation = Vector3(0, 3*3.14/2, 0)
		add_child(wallDoor)
		spawnenemy(Vector3(-1.5, 3, -67), Vector3(2, 2, 2), 30, 1.5, true, slimeRock)
		var children = get_children()
		for n in children:
			if n.is_in_group("Doors"):
				doorArray.append(n)
		slime5Spawned = true
		#await get_tree().create_timer(2).timeout
		#var i = 0
		#for n in doorArray:
			#n.queue_free()
			#doorArray.pop_at(i)
			#i += 1

func _on_slime_area_7_area_entered(area):
	if area.is_in_group("LeftHand") && !slime7Spawned:
		var wallDoor = wall.instantiate()
		wallDoor.position = Vector3(-20, .585, -50)
		add_child(wallDoor)
		spawnenemy(Vector3(-22, 3,-60), Vector3(2, 2, 2), 30, 1.5, true, slimeRock)
		var children = get_children()
		for n in children:
			if n.is_in_group("Doors"):
				doorArray.append(n)
		slime7Spawned = true

func _on_slime_area_8_area_entered(area):
	if area.is_in_group("LeftHand") && !slime8Spawned:
		var wallDoor = wall.instantiate()
		wallDoor.position = Vector3(16.5, .585, -74)
		add_child(wallDoor)
		spawnenemy(Vector3(18, 3, -83.5), Vector3(2, 2, 2), 30, 1.5, true, slimeRock)
		var children = get_children()
		for n in children:
			if n.is_in_group("Doors"):
				doorArray.append(n)
		slime8Spawned = true
