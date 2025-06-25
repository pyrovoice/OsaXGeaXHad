extends Node3D

@export var move_speed := 10.0
@export var rotate_speed := 0.01
@export var zoom_speed := 5.0
@export var zoom_min := 2.0
@export var zoom_max := 20.0
@export var zoom_lerp_speed := 8.0
@export var rotation_lerp_speed := 15.0

var rotation_enabled := false
var last_mouse_position := Vector2.ZERO

var target_rotation := Vector2.ZERO
var current_rotation := Vector2.ZERO
var target_zoom := 10.0
var current_zoom := 10.0
@onready var spring_arm := $SpringArm3D

func _ready():
	target_zoom = spring_arm.spring_length
	current_zoom = target_zoom
	current_rotation = Vector2(rotation_degrees.x, $SpringArm3D.rotation_degrees.x)
	target_rotation = current_rotation

func _process(delta):
	handle_movement(delta)
	handle_zoom()

func handle_movement(delta):
	var dir := Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		dir -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		dir += transform.basis.z
	if Input.is_action_pressed("move_left"):
		dir -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		dir += transform.basis.x

	dir.y = 0  # Lock Y movement
	if dir != Vector3.ZERO:
		translate(dir.normalized() * move_speed * delta)
		
		
func handle_zoom():
	var scroll := (-1 if Input.is_action_just_released("MWU") else 0) + (1 if Input.is_action_just_released("MWD") else 0)
	if scroll != 0:
		spring_arm.spring_length = clamp(
			spring_arm.spring_length + scroll * zoom_speed,
			zoom_min,
			zoom_max
		)
