extends StaticBody3D
class_name Character

@export var data: CharacterData = CharacterData.new()
@onready var nav: Nav3DCustom = $NavigationAgent3D

func _ready():
	nav.navigation_finished.connect(func(): print("REACHEEEED"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
