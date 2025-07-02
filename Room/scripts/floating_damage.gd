extends Node3DFacingCamera

var lifespan: float = 3.0
var timer: float = 0.0
var float_speed: float = 1.0
var sway_amplitude: float = 0.5
var sway_frequency: float = 2.0


func init(text: String, color: Color = Color.RED, lifespanSecond: float = 3.0) -> void:
	get_child(0).text = text
	get_child(0).modulate = color
	self.lifespan = lifespanSecond
	
func _process(delta: float) -> void:
	timer += delta
	
	# Upward movement
	position.y += float_speed * delta
	
	# Left-right sway using sine wave
	position.x = sway_amplitude * sin(timer * sway_frequency * PI * 2)
	
	# Lifespan check
	if timer >= lifespan:
		queue_free()
