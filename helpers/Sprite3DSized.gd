extends Sprite3D
class_name Sprite3DSized

func _ready():
	# Desired fixed size in 3D units
	var fixed_width = 0.8
	var fixed_height = 0.8

	# Get texture size in pixels
	var tex_size = texture.get_size()

	# Compute scale to achieve fixed size
	scale.x = fixed_width / tex_size.x *100
	scale.y = fixed_height / tex_size.y *100
	scale.z = 1.0  # Keep depth unchanged (can adjust if needed)
