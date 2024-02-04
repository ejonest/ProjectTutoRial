extends Node3D

var rot_x = 0
#var rot_y = 0
var sensitivity = 0.005

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_KP_SUBTRACT:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
		
		if event.pressed and event.keycode == KEY_KP_ADD:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
	
	if event is InputEventMouseMotion:
		# modify accumulated mouse rotation
		rot_x -= event.relative.x * sensitivity
		#rot_y += event.relative.y * sensitivity
		transform.basis = Basis() # reset rotation
		rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
		#rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate in X
