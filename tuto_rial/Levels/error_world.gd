extends Node

@onready var slimeWhite = load("res://Enemies/slimeWhite.tscn")
var enemyArray : Array
var exitPortal

func _ready():
	spawnenemy(Vector3(4, 0, -110), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	spawnenemy(Vector3(8, 0, -110), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	spawnenemy(Vector3(4, 0, -90), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	spawnenemy(Vector3(8, 0, -90), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	spawnenemy(Vector3(4, 0, -70), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	spawnenemy(Vector3(8, 0, -70), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	spawnenemy(Vector3(4, 0, -50), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	spawnenemy(Vector3(8, 0, -50), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	spawnenemy(Vector3(4, 0, -30), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	spawnenemy(Vector3(8, 0, -30), Vector3(5, 5, 5), 30, 2, false, slimeWhite)
	exitPortal = get_tree().get_nodes_in_group("Portal")[1]
	exitPortal.changeScene.connect(ReturnHome)
	pass

func _process(delta):
	var i = 0
	for n in enemyArray:
		if n.getHealth() <= 0:
			n.queue_free()
			enemyArray.pop_at(i)
		i += 1
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
	print("Size A: ", enemyArray.size())
	for n in children:
		if n.is_in_group("Enemy"):
			enemyArray.append(n)
	print("Size B: ", enemyArray.size())
	pass

func removeenemy():
	#if enemy:
		#enemy.queue_free()
	#spawnenemy()
	pass
