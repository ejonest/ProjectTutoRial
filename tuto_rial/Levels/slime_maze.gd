extends Node3D

@onready var slimePlain = load("res://Enemies/slime.tscn")
@onready var slimeTeal = load("res://Enemies/slimeTeal.tscn")
@onready var slimeWhite = load("res://Enemies/slimeWhite.tscn")
@onready var slimeRock = load("res://Enemies/slimeRock.tscn")

@onready var wall = load("res://Asset/Environment/Scene/wallDoor.tscn")
#-11.5, .585, -14
var enemyArray : Array
var doorArray : Array
var gotKey = false

func _ready():
# To spawn an enemy you need to pass it a location(vector3), a scaling(vector3), 
# health(int), speed(float), if they can take damage(bool), and the type of slime
	#spawnenemy(Vector3(-5, 1, -12), Vector3(5, 5, 5), 30, 1.5, true, slimePlain)
	#spawnenemy(Vector3(5, 1, -12), Vector3(5, 5, 5), 10, 1.5, true, slimeTeal)
	#spawnenemy(Vector3(-3, 5, -40), Vector3(5, 5, 5), 30, 1.5, true, slimeWhite)
	#spawnenemy(Vector3(3, 5, -40), Vector3(5, 5, 5), 10, 1.5, true, slimeRock)
	#var wallDoor = wall.instantiate()
	#print(wallDoor)
	#wallDoor.position = Vector3(-11.5, .585, -14)
	#wallDoor.rotation = Vector3(0, -3.14 / 2, 0)
	#add_child(wallDoor)
	#var children = get_children()
	##print("Size A: ", doorArray.size())
	#for n in children:
		#if n.is_in_group("Enemy"):
			#enemyArray.append(n)
		#elif n.is_in_group("Doors"):
			#doorArray.append(n)
	##print("Size B: ", doorArray.size())
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

#Slime Encounter Areas
func _on_slime_area_1_area_entered(area):
	if area.is_in_group("LeftHand"):
		var wallDoor = wall.instantiate()
		wallDoor.position = Vector3(-11.5, .585, -14)
		wallDoor.rotation = Vector3(0, -3.14 / 2, 0)
		add_child(wallDoor)
		var children = get_children()
		for n in children:
			if n.is_in_group("Enemy"):
				enemyArray.append(n)
			elif n.is_in_group("Doors"):
				doorArray.append(n)

func _on_slime_area_2_area_entered(area):
	if area.is_in_group("LeftHand"):
		var wallDoor = wall.instantiate()
		wallDoor.position = Vector3(28, .585, -26)
		wallDoor.scale = Vector3(4, .75, 1)
		add_child(wallDoor)
		var children = get_children()
		for n in children:
			if n.is_in_group("Enemy"):
				enemyArray.append(n)
			elif n.is_in_group("Doors"):
				doorArray.append(n)

func _on_slime_area_3_area_entered(area):
	if area.is_in_group("LeftHand"):
		var wallDoor = wall.instantiate()
		wallDoor.position = Vector3(-20, .585, -50)
		add_child(wallDoor)
		var children = get_children()
		for n in children:
			if n.is_in_group("Enemy"):
				enemyArray.append(n)
			elif n.is_in_group("Doors"):
				doorArray.append(n)


func _on_slime_area_4_area_entered(area):
	if area.is_in_group("LeftHand") && gotKey:
		var wallDoor = wall.instantiate()
		wallDoor.position = Vector3(8, .585, -54)
		add_child(wallDoor)
		wallDoor = wall.instantiate()
		wallDoor.position = Vector3(24, .585, -54)
		add_child(wallDoor)
		var children = get_children()
		for n in children:
			if n.is_in_group("Enemy"):
				enemyArray.append(n)
			elif n.is_in_group("Doors"):
				doorArray.append(n)

func _on_slime_area_5_area_entered(area):
	if area.is_in_group("LeftHand") && !gotKey:
		gotKey = true
		var wallDoor = wall.instantiate()
		wallDoor.position = Vector3(20.5, .585, -62)
		wallDoor.rotation = Vector3(0, -3.14 / 2, 0)
		add_child(wallDoor)
		var children = get_children()
		for n in children:
			if n.is_in_group("Enemy"):
				enemyArray.append(n)
			elif n.is_in_group("Doors"):
				doorArray.append(n)
		await get_tree().create_timer(2).timeout
		var i = 0
		for n in doorArray:
			n.queue_free()
			doorArray.pop_at(i)
			i += 1

func _on_slime_area_6_area_entered(area):
	if area.is_in_group("LeftHand") && !gotKey:
		gotKey = true
		var wallDoor = wall.instantiate()
		wallDoor.position = Vector3(20.5, .585, -62)
		wallDoor.rotation = Vector3(0, -3.14 / 2, 0)
		add_child(wallDoor)
		var children = get_children()
		for n in children:
			if n.is_in_group("Enemy"):
				enemyArray.append(n)
			elif n.is_in_group("Doors"):
				doorArray.append(n)
		await get_tree().create_timer(2).timeout
		var i = 0
		for n in doorArray:
			n.queue_free()
			doorArray.pop_at(i)
			i += 1
