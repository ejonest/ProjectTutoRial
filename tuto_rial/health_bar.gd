extends TextureProgressBar

func _ready():
	%TestTuto.healthChange.connect(update)
	update()
	
func update():
	value = (%TestTuto.playerHealth * 100 / %TestTuto.maxPlayerHealth) 
