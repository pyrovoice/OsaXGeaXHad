extends NavigationAgent3D
class_name Nav3DCustom

func setTarget(position: Vector3) -> PackedVector3Array:
	set_target_position(position)
	if !is_target_reachable() || is_navigation_finished():
		return []
	return get_current_navigation_path()
