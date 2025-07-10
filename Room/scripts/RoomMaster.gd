extends Node3D
class_name RoomMaster

@onready var ally: Character = $Ally
@onready var player_control: PlayerControl = $PlayerControl
@onready var location_indicator = $locationIndicator
@onready var end_turn_button:Button = $UI/endTurn/endTurnButton
@onready var target_indicator = $targetIndicator

var playerControl = true
var characterMovementTween: Tween
var selectedTarget: Character = null
var lastShownCover: Cover = null

func _ready():
	player_control.on_mouse_move.connect(onMouseMove)
	player_control.on_mouse_click.connect(onMouseClick)
	end_turn_button.pressed.connect(endTurn)


func onMouseMove(position, collider):
	resetDisplays()
	if collider is Character:
		draw3D.line(getTargetPosition(ally) + Vector3(0, 1, 0), getTargetPosition(collider) + Vector3(0, 1, 0))
	elif collider is Cover:
		showCover(collider)
		highlightPathTo(getTargetPosition(collider))
	else:
		highlightPathTo(position)
		
func onMouseClick(position, collider):
	resetDisplays()
	if collider is Character:
		if selectedTarget && selectedTarget == collider:
			attack(ally, selectedTarget)
		elif !selectedTarget && collider.data.team != ally.data.team:
			selectedTarget = collider
			draw3D.line(getTargetPosition(ally) + Vector3(0, 1, 0), getTargetPosition(collider) + Vector3(0, 1, 0), Color.RED)
	elif collider is Cover:
		showCover(collider)
		tryMoveCharacterTo(getTargetPosition(collider))
	else:
		tryMoveCharacterTo(position)
		
func getTargetPosition(entity):
	if entity is Character:
		return entity.global_position
	elif entity is Cover:
		return entity.global_position
		
func resetDisplays():
	draw3D.erase()
	target_indicator.hide()
	location_indicator.hide()
	if lastShownCover:
		lastShownCover._hide()
		lastShownCover = null
	
func createMovementDataTo(position) -> MovementData:
	var mov:MovementData = MovementData.new()
	var points: PackedVector3Array = ally.nav.setTarget(position)
	var distanceCount = 0
	var i = 1
	while i < points.size():
		if mov.energyUsedPoints.size() >= ally.data.actionPointCurrent:
			break
		if distanceCount + points[i-1].distance_to(points[i]) > ally.data.movementSpeed:
			var vectorToPoint = (points[i] - points[i-1]).normalized()*(ally.data.movementSpeed - distanceCount)
			var newPoint = points[i-1] + vectorToPoint
			points.insert(i, newPoint)
			mov.energyUsedPoints.push_back(newPoint)
			distanceCount = 0
		elif points.size() - 1 == i:
			if mov.energyUsedPoints.size() == 0 || points[i].distance_to(mov.energyUsedPoints[mov.energyUsedPoints.size()-1]) > 2:
				mov.energyUsedPoints.push_back(points[i])
				mov.subMovements.push_back(points[i])
			break
		else:
			distanceCount += points[i-1].distance_to(points[i])
		mov.subMovements.push_back(points[i])
		i += 1
	return mov
	
func highlightPathTo(position):
	if !playerControl:
		return
	var movementData:MovementData = createMovementDataTo(position)
	if(movementData.subMovements.size() == 0):
		return
	movementData.subMovements.insert(0, ally.global_position) #Display from character
	for i in range(1, movementData.subMovements.size()):
		draw3D.line(movementData.subMovements[i-1] + Vector3(0, 1, 0), movementData.subMovements[i] + Vector3(0, 1, 0))
	for point in movementData.energyUsedPoints:
		draw3D.point(point + Vector3(0, 1, 0), 0.2)
	location_indicator.show()
	location_indicator.position = movementData.subMovements[movementData.subMovements.size()-1]
	
func tryMoveCharacterTo(position):
	if !playerControl:
		return
	playerControl = false
	location_indicator.hide()
	var movementData:MovementData = createMovementDataTo(position)
	while movementData.subMovements.size() > 0:
		await move_to_position(ally, movementData.subMovements[0], 10)
		var dist = 0.5 if movementData.subMovements.size()>1 else 0.1
		if ally.position.distance_to(movementData.subMovements[0]) <= dist:
			movementData.subMovements.remove_at(0)
	ally.data.actionPointCurrent -= movementData.energyUsedPoints.size()
	playerControl = true
	
			
func move_to_position(node: Node3D, target: Vector3, speed: float) -> void:
	var direction = (target - node.global_transform.origin).normalized()
	node.global_translate(direction * speed * get_process_delta_time())
	await get_tree().process_frame

func endTurn():
	ally.data.actionPointCurrent = ally.data.actionPointMax
	
const FLOATING_DAMAGE = preload("res://helpers/floating_damage.tscn")
func attack(from: Character, to: Character):
	if from.data.actionPointCurrent <= 0:
		print("No energy")
		return
	to.receiveDamage(from.data.damage)
	from.data.actionPointCurrent -= 1
	var inst = FLOATING_DAMAGE.instantiate()
	add_child(inst)
	inst.init(str(from.data.damage), Color.RED, 2.5)
	inst.position = to.position + Vector3(0, 2, 0)

func showCover(cover: Cover):
	lastShownCover = cover
	lastShownCover._show()
