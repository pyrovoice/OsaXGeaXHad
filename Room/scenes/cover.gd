extends StaticBody3D
class_name Cover

@onready var sprite_3d = $Sprite3D

func _hide():
	sprite_3d.hide()
	
	
func _show():
	sprite_3d.show()
