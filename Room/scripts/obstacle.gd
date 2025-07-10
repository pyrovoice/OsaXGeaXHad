extends StaticBody3D

@onready var collision_shape_3d:CollisionShape3D  = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
const COVER = preload("res://Room/scenes/cover.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	(collision_shape_3d.shape as BoxShape3D).size = mesh_instance_3d.mesh.get_aabb().size
	createCovers()

func createCovers():
	var size = mesh_instance_3d.mesh.get_aabb().size
	for i in range(0, size.x):
		addCover(Vector3(i, 0, size.y/2 +0.01))
		#addCover(Vector3(i, 0, -size.y/2 -0.01))
		
func addCover(pos: Vector3, orientation: Vector2 = Vector2(0, 0)):
	var inst = COVER.instantiate()
	add_child(inst)
	inst.position = pos
	inst.rotation = Vector3(orientation.x, 0, orientation.y)
	inst._hide()
