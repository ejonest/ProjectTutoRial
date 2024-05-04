extends Node

@onready var slimeWhite = load("res://Enemies/slimeWhite.tscn")
var enemyArray : Array
var exitPortal
var canFlipLights = true
var player
var reloadingScene = false
var paused = false

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	spawnenemy(Vector3(4, 0, -110), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	spawnenemy(Vector3(4, 0, -90), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	spawnenemy(Vector3(4, 0, -70), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	spawnenemy(Vector3(4, 0, -50), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	spawnenemy(Vector3(4, 0, -30), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	exitPortal = get_tree().get_nodes_in_group("Portal")[1]
	exitPortal.changeScene.connect(ReturnHome)
	for n in get_tree().get_nodes_in_group("Lights"):
				n.visible = false
	Engine.time_scale = 1
	pass

func _process(delta):
	var i = 0
	for n in enemyArray:
		if n.getHealth() <= 0:
			n.queue_free()
			enemyArray.pop_at(i)
		i += 1
	if Input.is_action_just_pressed("path") && canFlipLights:
		flipLights()
	if player.playerHealth == 0:
		ReloadScene()
	
	if Input.is_action_just_pressed("esc"):
		pauseMenu()
		
	pass

func ReloadScene():
	if !reloadingScene:
		player.moveOn = 0
		reloadingScene = true
		print("reloading")
		await get_tree().create_timer(5).timeout
		get_tree().change_scene_to_file.bind("res://Levels/error_world.tscn").call_deferred()
		pass
		
func ReturnHome():
	player.moveOn = 0
	print("exiting")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file.bind("res://main.tscn").call_deferred()
	print("should have exited")
	pass
	
func flipLights():
	canFlipLights = false
	for n in get_tree().get_nodes_in_group("Lights"):
			n.visible = true
	await get_tree().create_timer(3).timeout
	for n in get_tree().get_nodes_in_group("Lights"):
			n.visible = false
	print("waiting")
	await get_tree().create_timer(10).timeout
	print("Done waiting")
	canFlipLights = true
	
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

func pauseMenu():
	if paused:
		$CameraController/SpringArm3D/Camera3D/PauseMenu.hide()
		Engine.time_scale = 1
	else:
		$CameraController/SpringArm3D/Camera3D/PauseMenu.show()
		Engine.time_scale = 0
		
	paused = !paused
