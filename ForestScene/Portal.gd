extends Node3D

var coinRequired : int = 3
@onready var textLabel : Label = $Sprite3D/SubViewport/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	textLabel.text = str(coinRequired)



func _on_area_3d_body_entered(body):
	if body.is_in_group("Tuto"):
		print("Tuto entered portal")
	else:
		print("Tuto cannot enter portal")
