extends Node

@onready var slimePlain = load("res://Enemies/slime.tscn")
@onready var slimeTeal = load("res://Enemies/slimeTeal.tscn")
@onready var slimeWhite = load("res://Enemies/slimeWhite.tscn")
@onready var slimeRock = load("res://Enemies/slimeRock.tscn")
var enemyArray : Array

func _ready():
# To spawn an enemy you need to pass it a location(vector3), a scaling(vector3), 
# health(int), speed(float), if they can take damage(bool), and the type of slime
	spawnenemy(Vector3(-5, 1, -12), Vector3(5, 5, 5), 30, 1.5, true, slimePlain)
	spawnenemy(Vector3(5, 1, -12), Vector3(5, 5, 5), 10, 1.5, true, slimeTeal)
	spawnenemy(Vector3(-3, 5, -40), Vector3(5, 5, 5), 30, 1.5, true, slimeWhite)
	spawnenemy(Vector3(3, 5, -40), Vector3(5, 5, 5), 10, 1.5, true, slimeRock)
	pass

func _process(delta):
	var i = 0
	for n in enemyArray:
		if n.getHealth() <= 0:
			n.queue_free()
			enemyArray.pop_at(i)
		i += 1
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
