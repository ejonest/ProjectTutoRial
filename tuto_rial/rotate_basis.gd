extends Node3D

var rot_x = 0
var sensitivity = 0.05

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_KP_SUBTRACT:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
		
		if event.pressed and event.keycode == KEY_KP_ADD:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
	
	if event is InputEventMouseMotion:
		# modify accumulated mouse rotation
		rot_x -= event.relative.x * sensitivity
		transform.basis = Basis() # reset rotation
		
		if (event.relative.x > 0):
			rotate_object_local(Vector3(0, 1, 0), -sensitivity) # first rotate in Y
			%player_body.rotate_object_local(Vector3(0, 1, 0), -sensitivity)
			
		if (event.relative.x < 0):	
			rotate_object_local(Vector3(0, 1, 0), sensitivity) # first rotate in Y
			%player_body.rotate_object_local(Vector3(0, 1, 0), sensitivity)
