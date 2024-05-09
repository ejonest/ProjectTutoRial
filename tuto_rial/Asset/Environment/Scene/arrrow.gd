extends Node3D

var player
var pointTo
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	pointTo = get_tree().get_nodes_in_group("ExitPortal")[0]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = Vector3(player.global_position.x, player.global_position.y + 1, player.global_position.z)
	look_at(Vector3(pointTo.get_node("Orgin").global_position.x, global_position.y,
		pointTo.get_node("Orgin").global_position.z))
	pass
