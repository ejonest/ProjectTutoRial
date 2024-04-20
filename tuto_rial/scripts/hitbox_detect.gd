extends MeshInstance3D

func _input(event):
	if Input.is_action_pressed("click"):
		visible = not visible
