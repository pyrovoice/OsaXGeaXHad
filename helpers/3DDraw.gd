extends Node

var refresh = false;
var previouslyDrawnElements: Array[MeshInstance3D] = []

func _process(delta):
	refresh = true;
	
func line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE, persist_ms = 1):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	return eraseAndDraw(mesh_instance)

func point(pos: Vector3, radius = 0.05, color = Color.WHITE_SMOKE, persist_ms = 1):
	var mesh_instance := MeshInstance3D.new()
	var sphere_mesh := SphereMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = sphere_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance.position = pos

	sphere_mesh.radius = radius
	sphere_mesh.height = radius*2
	sphere_mesh.material = material

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	return eraseAndDraw(mesh_instance)

func square(pos: Vector3, size: Vector2, color = Color.WHITE_SMOKE, persist_ms = 1):
	var mesh_instance := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = box_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance.position = pos

	box_mesh.size = Vector3(size.x, size.y, 1)
	box_mesh.material = material

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	return eraseAndDraw(mesh_instance)
	
func erase():
	for elem in previouslyDrawnElements:
		elem.queue_free()
	previouslyDrawnElements = []
	refresh = false
	
func eraseAndDraw(mesh_instance: MeshInstance3D):
	if refresh:
		erase()
	previouslyDrawnElements.push_back(mesh_instance)
	get_tree().get_root().add_child(mesh_instance)
