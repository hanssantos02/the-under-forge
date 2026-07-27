extends Control


func _on_play_button_pressed() -> void:
	TransitionScreen.transition("res://scenes/main.tscn")
	

func _on_quit_button_pressed() -> void:
	get_tree().quit()
