extends NavigationAgent3D
class_name Nav3DCustom

func setTarget(position: Vector3) -> PackedVector3Array:
	set_target_position(position)
	var reach = is_target_reachable()
	var finished = is_navigation_finished()
	if !reach || finished:
		return []
	return get_current_navigation_path()
