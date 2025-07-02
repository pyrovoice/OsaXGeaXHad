extends StaticBody3D
class_name Character

@export var data: CharacterData = CharacterData.new()
@onready var nav: Nav3DCustom = $NavigationAgent3D
@onready var collider = $Collider
@onready var appearance: Sprite3D = $Node3DFacingCamera/Sprite3D

func _ready():
	appearance.position.y = appearance.texture.get_height()/100

func receiveDamage(damage: float):
	data.lifeCurrent -= damage
	if data.lifeCurrent <= 0:
		queue_free()
