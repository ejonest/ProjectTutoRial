extends Node3D

var player
@export var h_sensitivity := 2
@export var v_sensitivity := 1
var cam_speed := 0.1
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = player.global_position
	$SpringArm3D/Camera3D.look_at(player.get_node("LookAt").global_position)
	pass

func _input(event):
	if event is InputEventMouseMotion:
		var tempRot = rotation.x - event.relative.y / 1000 * v_sensitivity
		rotation.y -= event.relative.x / 1000 * h_sensitivity
# Bind the vertical camera rotation between 0 and .25 to not go over or under bounds
		tempRot = clamp(tempRot, -.75, .5)
		rotation.x = tempRot
		
	if Input.is_action_just_pressed("esc") && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
	elif Input.is_action_just_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
