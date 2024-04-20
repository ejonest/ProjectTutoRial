extends Node

@onready var enemy_scene = load("res://slime.tscn")
var enemyArray : Array

func _ready():
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector3(-5, 1, -12)
	enemy.scale = Vector3(5, 5, 5)
	add_child(enemy)
	var children = get_children()
	print("Size A: ", enemyArray.size())
	for n in children:
		if n.is_in_group("Enemy"):
			enemyArray.append(n)
	print("Size B: ", enemyArray.size())
	pass

func _process(delta):
	var i = 0
	for n in enemyArray:
		if n.getHealth() <= 0:
			n.queue_free()
			enemyArray.pop_at(i)
		i += 1
	pass

func spawnenemy():
	#enemy = enemy_scene.instantiate()
	#add_child(enemy)
	#print("spawn!")
	pass

func removeenemy():
	#if enemy:
		#enemy.queue_free()
	#spawnenemy()
	pass
