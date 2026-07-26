extends Node2D

@export var player_scene: PackedScene
@export var enemy_scene: PackedScene
@onready var spawn_location: PathFollow2D = $SpawnPath/SpawnLocation
@onready var spawn_timer: Timer = $SpawnTimer
@onready var death_sfx: AudioStreamPlayer = $DeathSFX
@onready var difficulty_timer: Timer = $DifficultyTimer
var is_respawning: bool = false
var minimum_spawn_time: float = 0.3

func _on_player_died() -> void:
	is_respawning = true
	spawn_timer.stop()
	difficulty_timer.stop()
	death_sfx.play()
	
func _unhandled_input(event: InputEvent) -> void:
	if is_respawning and event.is_action_pressed("ui_accept"):
		is_respawning = false
		spawn_timer.start()
		spawn_timer.wait_time = 2.0
		difficulty_timer.start()
		var player = player_scene.instantiate()
		player.global_position = Vector2.ZERO
		player.has_weapon = false
		get_tree().current_scene.add_child(player)
		player.add_to_group("player")
		player.tree_exited.connect(_on_player_died)

func _on_spawn_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		$SpawnPath.global_position = player.global_position
	var spawn = randf_range(0.0, 1.0)
	spawn_location.progress_ratio = spawn
	var new_enemy = enemy_scene.instantiate()
	new_enemy.global_position = spawn_location.global_position
	get_tree().current_scene.add_child(new_enemy)
	new_enemy.add_to_group("enemy")


func _on_difficulty_timer_timeout() -> void:
	spawn_timer.wait_time = maxf(minimum_spawn_time, spawn_timer.wait_time - 0.1)
