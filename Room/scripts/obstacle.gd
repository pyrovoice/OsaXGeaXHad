extends StaticBody3D

@onready var collision_shape_3d:CollisionShape3D  = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
const COVER = preload("res://Room/scenes/cover.tscn")
const distanceToCoverpoint = 0.5
# Called when the node enters the scene tree for the first time.
func _ready():
	var size = Vector3(scale.x, scale.y, scale.z)
	scale = Vector3.ONE
	mesh_instance_3d.scale = size
	(collision_shape_3d.shape as BoxShape3D).size = mesh_instance_3d.mesh.get_aabb().size
	createCovers()

func createCovers():
	var size = mesh_instance_3d.scale
	for i in range(0, size.x):
		addCover(Vector3(i - ((size.x - 1) / 2), 0, size.z/2 + distanceToCoverpoint))
		addCover(Vector3(i - ((size.x - 1) / 2), 0, -size.z/2 - distanceToCoverpoint), 180)
	
	for i in range(0, size.z):
		addCover(Vector3(-size.x/2- distanceToCoverpoint, 0, i - ((size.z - 1) / 2)), 270)
		addCover(Vector3(size.x/2+ distanceToCoverpoint, 0, i - ((size.z - 1) / 2)), 90)
		
func addCover(pos: Vector3, orientationX = 0):
	var inst = COVER.instantiate()
	add_child(inst)
	inst.position = pos
	inst.rotate_y(deg_to_rad(orientationX))
	#inst._hide()
