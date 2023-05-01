extends PointLight2D


@onready var target_scale: float = 1.0

var random = RandomNumberGenerator.new()


func _process(delta):
	if abs(scale.x - target_scale) < 0.001:
		target_scale = random.randf_range(0.6, 1.6)
	
	var factor = 0.95 if target_scale < scale.x else 1.05
	scale *= Vector2.ONE * factor
