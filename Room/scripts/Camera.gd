extends Node3D

@export var move_speed := 10.0
@export var rotate_speed := 0.01
@export var zoom_speed := 5.0
@export var zoom_min := 2.0
@export var zoom_max := 20.0
@export var zoom_lerp_speed := 8.0
@export var rotation_lerp_speed := 5.0

var rotation_enabled := false
var last_mouse_position := Vector2.ZERO

var target_rotation := Vector2.ZERO
var current_rotation := Vector2.ZERO
var target_zoom := 10.0
var current_zoom := 10.0
var camera_angle_min = 0.10
var camera_angle_max = 0.20
@onready var spring_arm := $SpringArm3D
@onready var camera_3d = $SpringArm3D/Camera3D
@onready var room = $".."

func _ready():
	target_zoom = spring_arm.spring_length
	current_zoom = target_zoom
	current_rotation = Vector2(rotation_degrees.x, $SpringArm3D.rotation_degrees.x)
	target_rotation = current_rotation

func _process(delta):
	if room.playerControl == false:
		return
	handle_movement(delta)
	handle_zoom()

func handle_movement(delta):
	var dir := Vector3.ZERO
	var forward = -global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()
	var right = global_transform.basis.x
	right.y = 0
	right = right.normalized()
	if Input.is_action_pressed("move_forward"):
		dir += forward
	if Input.is_action_pressed("move_backward"):
		dir -= forward
	if Input.is_action_pressed("move_left"):
		dir -= right
	if Input.is_action_pressed("move_right"):
		dir += right

	if dir != Vector3.ZERO:
		global_translate(dir.normalized() * move_speed * delta)
		
		
func handle_zoom():
	var scroll := (-1 if Input.is_action_just_released("MWU") else 0) + (1 if Input.is_action_just_released("MWD") else 0)
	if scroll != 0:
		spring_arm.spring_length = clamp(
			spring_arm.spring_length + scroll * zoom_speed,
			zoom_min,
			zoom_max
		)

var middleMouseOn = false
func _unhandled_input(event):
	if room.playerControl == false:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE and event.pressed:
			middleMouseOn = true
		if event.button_index == MOUSE_BUTTON_MIDDLE and !event.pressed:
			middleMouseOn = false
			
	if middleMouseOn && event is InputEventMouseMotion:
		rotate_y((event as InputEventMouseMotion).relative.x*rotation_lerp_speed*-0.001)
		if((event as InputEventMouseMotion).relative.x == 0):
			var cameraRotateX = ((event as InputEventMouseMotion).relative.y*rotation_lerp_speed*0.001)/2
			camera_3d.rotation.x = clamp(camera_3d.rotation.x + cameraRotateX, camera_angle_min, camera_angle_max)
		
