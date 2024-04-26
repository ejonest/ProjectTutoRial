extends Node

@onready var slimeTeal = load("res://Enemies/slimeTeal.tscn")
var enemyArray : Array
var exitPortal
var canFlipLights = true
var slimesHaveSpawned = false
var player
var reloadingScene = false

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	spawnenemy(Vector3(-24, 29, -20), Vector3(3, 3, 3), 10, 1.5, true, slimeTeal)
	spawnenemy(Vector3(-18, 29, -5), Vector3(2, 2, 2), 6, 1.5, true, slimeTeal)
	spawnenemy(Vector3(-18, 29, 14), Vector3(2, 2, 2), 6, 1.5, true, slimeTeal)
	spawnenemy(Vector3(38, 29, -20), Vector3(4, 4, 4), 30, 1, true, slimeTeal)
	exitPortal = get_tree().get_nodes_in_group("Portal")[2]
	exitPortal.changeScene.connect(ReturnHome)
	for n in get_tree().get_nodes_in_group("Lights"):
				n.visible = false
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
	pass

func ReloadScene():
	if !reloadingScene:
		reloadingScene = true
		print("reloading")
		await get_tree().create_timer(5).timeout
		get_tree().change_scene_to_file.bind("res://Levels/ForestScene.tscn").call_deferred()
		pass
		
func ReturnHome():
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
			spawnenemy(Vector3(-40, 29, -5), Vector3(2, 2, 2), 10, 3, true, slimeTeal)
			spawnenemy(Vector3(31, 29, --7), Vector3(4, 4, 4), 10, 3, true, slimeTeal)
			slimesHaveSpawned = true
