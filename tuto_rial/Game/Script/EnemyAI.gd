extends CharacterBody3D


const SPEED = .2
@onready var navAgent : NavigationAgent3D = $NavigationAgent3D
var player : Node3D
@onready var visual :Node3D = $Slime
#@onready var animationPlayer: AnimationPlayer = $SlimeBasicModel/AnimationPlayer

var direction: Vector3
var stopDistance : float = 1

var health = 10

func _ready():
	#player = get_tree().get_first_node_in_group("Player")
	#animationPlayer.play("Leap")
	pass
	

func _physics_process(delta):
	
	navAgent.target_position = player.global_position
	direction = navAgent.get_next_path_position() - global_position
	direction.normalized()
	
	if navAgent.distance_to_target() < stopDistance:
		return
		
	velocity = velocity.lerp(direction*SPEED,delta)
	#animationPlayer.play("Attack")
	
	if velocity.length() > 0.2:
		var lookDir = Vector2(velocity.z, velocity.x)
		visual.rotation.y = lookDir.angle()
	move_and_slide()
	
func hit():
	health -= 1;
	print(health)
