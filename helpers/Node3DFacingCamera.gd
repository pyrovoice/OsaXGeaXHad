extends Node3D
class_name Node3DFacingCamera

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
	look_at(global_transform.origin + target_direction, Vector3.UP)
