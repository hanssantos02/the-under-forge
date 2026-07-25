extends Sprite2D

@export var camera_2d: Camera2D

func _process(delta: float) -> void:
	var weapon = get_tree().get_first_node_in_group("dropped_weapon")
	if weapon == null:
		hide()
		return
	else:
		show()
	var screen_size = get_viewport_rect().size
	var screen_center = screen_size / 2.0
	var camera_center = camera_2d.get_screen_center_position()
	var difference: Vector2 = weapon.global_position - camera_center
	var bounds: Vector2 = screen_center - Vector2(20, 20)
	var clamped_difference: Vector2 = difference.clamp(-bounds, bounds)
	global_position = screen_center + clamped_difference
	rotation = difference.angle()
