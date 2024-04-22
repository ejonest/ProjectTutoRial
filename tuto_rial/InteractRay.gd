extends RayCast3D

func _ready():
	add_exception(owner)
	
func _physics_process(delta):
	if is_colliding():
		print("Would'ja look at that...")
