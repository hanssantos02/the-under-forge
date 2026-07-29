extends CanvasLayer

@onready var control: Control = $Control
@onready var gameover_label: Label = $Control/VBoxContainer/GameoverLabel
@onready var main: Node2D = $".."


func _on_retry_button_pressed() -> void:
	TransitionScreen.transition("res://scenes/main.tscn")


func _on_menu_button_pressed() -> void:
	TransitionScreen.transition("res://scenes/main_menu.tscn")

func appear() -> void:
	gameover_label.text = "LINEAGE BROKEN!" + "\nSCORE: " + str(main.score)
	control.pivot_offset = control.size / 2.0
	control.scale = Vector2(0.5, 0.5)
	control.modulate.a = 0.0
	show()
	var tween = create_tween().set_parallel(true)
	tween.tween_property(control, "scale", Vector2(1.0, 1.0), 1.0).set_trans(Tween.TRANS_BACK)
	tween. tween_property(control, "modulate:a", 1.0, 1.0)
