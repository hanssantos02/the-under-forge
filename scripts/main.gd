extends Node2D

@export var player_scene: PackedScene
var is_respawning: bool = false

func _on_player_died() -> void:
	print("This is working")
	is_respawning = true
	
func _unhandled_input(event: InputEvent) -> void:
	if is_respawning and event.is_action_pressed("ui_accept"):
		is_respawning = false
		var player = player_scene.instantiate()
		player.global_position = Vector2.ZERO
		player.starts_with_weapon = false
		get_tree().current_scene.add_child(player)
		player.add_to_group("player")
		player.tree_exited.connect(_on_player_died)
