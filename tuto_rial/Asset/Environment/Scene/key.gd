extends StaticBody3D

signal PickUp

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pick_up_box_area_entered(area):
	print("I have been touched by: ", area)
	if area.is_in_group("LeftHand") || area.is_in_group("RightHand"):
		PickUp.emit()
	pass # Replace with function body.
