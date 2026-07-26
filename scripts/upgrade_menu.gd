extends CanvasLayer

@export var player: CharacterBody2D

func _on_upgrade_1_pressed() -> void:
	player.weapon_pivot.stats.damage += 5.0
	player.weapon_pivot.update_appearance()
	get_tree().paused = false
	hide()


func _on_upgrade_2_pressed() -> void:
	player.weapon_pivot.stats.fire_rate = maxf(0.0, player.weapon_pivot.stats.fire_rate - 0.2)
	player.weapon_timer.wait_time = player.weapon_pivot.stats.fire_rate
	get_tree().paused = false
	hide()


func _on_upgrade_3_pressed() -> void:
	player.speed += 20.0
	get_tree().paused = false
	hide()
