extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func transition(target_scene_path: String) -> void:
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 0.5)
	await tween.finished
	get_tree().change_scene_to_file(target_scene_path)
	tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, 0.5)
	
