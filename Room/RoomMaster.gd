extends Node3D
class_name RoomMaster

@onready var ally: Character = $Ally
@onready var player_control: PlayerControl = $PlayerControl
@onready var location_indicator = $locationIndicator

var playerControl = true
var characterMovementTween: Tween

func _ready():
	player_control.on_mouse_move.connect(onMouseMove)
	player_control.on_mouse_click.connect(onMouseClick)

func onMouseMove(position, collider):
	if collider is Character:
		draw3D.line(ally.position + Vector3(0, 0.1, 0), collider.position + Vector3(0, 0.1, 0))
	else:
		highlightPathTo(position)
		
func onMouseClick(position, collider):
	if collider == Character:
		draw3D.line(ally.position, collider.position)
	else:
		tryMoveCharacterTo(position)
		
func highlightPathTo(position):
	if !playerControl:
		return
	location_indicator.show()
	var points:PackedVector3Array = ally.nav.setTarget(position)
	for i in range(1, points.size()):
		draw3D.line(points[i-1], points[i])
		draw3D.point(points[i] + Vector3(0, 1, 0))
	location_indicator.position = position
	
func tryMoveCharacterTo(position):
	if !playerControl:
		return
	playerControl = false
	location_indicator.hide()
	ally.nav.set_target_position(position)
	while !ally.nav.is_navigation_finished():
		await move_to_position(ally, ally.nav.get_next_path_position(), 5)
	playerControl = true
	
			
func move_to_position(node: Node3D, target: Vector3, speed: float) -> void:
	var direction = (target - node.global_transform.origin).normalized()
	node.global_translate(direction * speed * get_process_delta_time())
	await get_tree().process_frame
	
