extends Button

func _ready() -> void:
	pivot_offset = size / 2.0
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2).set_trans(Tween.TRANS_ELASTIC)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
	
func _on_button_down() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.1)
