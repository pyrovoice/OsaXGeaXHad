extends StaticBody3D
class_name Character

@export var data: CharacterData = CharacterData.new()
@onready var nav: Nav3DCustom = $NavigationAgent3D
@onready var collider = $Collider
@onready var appearance:Sprite3D = $Sprite3D

func _ready():
	nav.navigation_finished.connect(func(): print("REACHEEEED"))
	appearance.position.y = appearance.texture.get_height()/100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var camera = get_viewport().get_camera_3d()
	if camera == null:
		return
	
	# Camera forward direction (negative Z-axis)
	var camera_forward = -camera.global_transform.basis.z.normalized()
	
	# Desired look direction is opposite to where camera is facing
	var target_direction = -camera_forward
	
	# Apply this direction to all Sprite3D in the scene
	appearance.look_at(appearance.global_transform.origin + target_direction, Vector3.UP)
