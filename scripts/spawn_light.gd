extends Node2D

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.pivot_offset = Vector2(color_rect.size.x / 2.0, 0)
	color_rect.scale.y = 0.0
	var tween = create_tween()
	tween.tween_property(color_rect, "scale:y", 1.0, 0.1)
	tween.tween_property(color_rect, "scale:x", 0.0, 0.3)
	tween.parallel().tween_property(color_rect, "modulate:a", 0.0, 0.3)
	await tween.finished
	queue_free()
