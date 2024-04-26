extends Node3D

signal changeScene

var coinRequired : int = 3
@onready var textLabel : Label = $Sprite3D/SubViewport/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	#textLabel.text = str(coinRequired)
	pass

#func _on_area_3d_body_entered(body):
	#if body.is_in_group("Player"):
		#print("Tuto entered portal")
	#else:
		#print("Tuto cannot enter portal")

func _on_portal_ent_area_entered(area):
	if area.is_in_group("LeftHand") || area.is_in_group("RightHand"):
		print("I am a portal and I have been entered by tuto")
		changeScene.emit()
	pass # Replace with function body.
