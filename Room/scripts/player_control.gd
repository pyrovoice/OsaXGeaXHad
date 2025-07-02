extends Node3D
class_name PlayerControl

@onready var ally = $"../Ally"

signal on_mouse_move
signal on_mouse_click

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var result = mouseToPosition()
		if result:
			on_mouse_move.emit(result.position, result.collider)
			
	if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var result = mouseToPosition()
		if result:
			on_mouse_click.emit(result.position, result.collider)

	
func mouseToPosition():
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	return space_state.intersect_ray(query)
