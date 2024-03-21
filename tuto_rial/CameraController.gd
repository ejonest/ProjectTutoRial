extends Node3D

var tuto_rial
@export var sensitivity = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	tuto_rial = get_tree().get_nodes_in_group("TutoRialAnimated")[0]
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#rotation.z = tuto_rial.global_position.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = tuto_rial.global_position
	$SpringArm3D/Camera3D.look_at(tuto_rial.get_node("LookAt").global_position)
	pass

func _input(event):
	if event is InputEventMouseMotion:
		var tempRotation = rotation.x - event.relative.y / 1000 * sensitivity
		tempRotation = clamp(tempRotation, -1, -.5) # Floor than top of character
		rotation.x = tempRotation
		rotation.y -= event.relative.x / 1000 * sensitivity
