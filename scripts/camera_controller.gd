extends Camera2D

var shake_strength: float = 0.0
@export var fade_rate: float = 5.0

func apply_shake(amount: float) -> void:
	shake_strength = amount
	
func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0.0, fade_rate * delta)
		var rand_x = randf_range(-shake_strength, shake_strength)
		var rand_y = randf_range(-shake_strength, shake_strength)
		offset = Vector2(rand_x, rand_y)
