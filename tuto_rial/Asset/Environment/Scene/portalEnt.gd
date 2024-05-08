extends Node3D

signal changeScene

var coinRequired : int = 3
@onready var textLabel : Label = $Sprite3D/SubViewport/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	#textLabel.text = str(coinRequired)
	pass
	
