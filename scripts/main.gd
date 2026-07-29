extends Node2D

@export var player_scene: PackedScene
@export var enemy_scene: PackedScene
@export var swarmer_scene: PackedScene
@export var brute_scene: PackedScene
@export var boss_scene: PackedScene
@export var cage_scene: PackedScene
@onready var spawn_location: PathFollow2D = $SpawnPath/SpawnLocation
@onready var spawn_timer: Timer = $SpawnTimer
@onready var death_sfx: AudioStreamPlayer = $DeathSFX
@onready var difficulty_timer: Timer = $DifficultyTimer
@onready var game_over_menu: CanvasLayer = $GameOverMenu
@onready var hud: CanvasLayer = $HUD
var is_respawning: bool = false
var minimum_spawn_time: float = 0.3
var difficulty_level: int = 1
var is_game_over: bool = false
var survival_time: float
var score: int = 0
var next_boss_time: float = 10.0
var is_boss_active: bool = false
var cage_center: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	survival_time += delta
	var survival_seconds: int = int(survival_time)
	var minutes = survival_seconds / 60
	var seconds = survival_seconds % 60
	var time_string: String = "%02d:%02d" % [minutes, seconds]
	hud.update_time(time_string)
	if survival_time >= next_boss_time:
		next_boss_time += 120.0
		start_boss_fight()

func _on_player_died() -> void:
	is_respawning = true
	spawn_timer.stop()
	difficulty_timer.stop()
	death_sfx.play()
	if not is_game_over:
		hud.show_respawn_prompt(true)
	
func _unhandled_input(event: InputEvent) -> void:
	if is_respawning and event.is_action_pressed("ui_accept") and not is_game_over:
		is_respawning = false
		hud.show_respawn_prompt(false)
		
		var player = player_scene.instantiate()
		player.has_weapon = false
		
		if is_boss_active:
			player.global_position = cage_center
		else:
			player.global_position = Vector2.ZERO
			spawn_timer.start()
			spawn_timer.wait_time = minf(2.0, spawn_timer.wait_time + 0.5)
			difficulty_level = 1
			difficulty_timer.start()
		
		
		
		get_tree().current_scene.add_child(player)
		player.add_to_group("player")
		player.tree_exited.connect(_on_player_died)
		player.lineage_broken.connect(_on_lineage_broken)
		player.dash_status_changed.connect(hud.set_dash_ready)
		player.xp_changed.connect(hud.update_xp)

func _on_spawn_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		$SpawnPath.global_position = player.global_position
	var spawn = randf_range(0.0, 1.0)
	spawn_location.progress_ratio = spawn
	var enemy_to_spawn = enemy_scene
	if difficulty_level >= 5:
		var enemy_rate = randf()
		if enemy_rate <= 0.15:
			enemy_to_spawn = brute_scene
		elif enemy_rate <= 0.45:
			enemy_to_spawn = swarmer_scene
	elif difficulty_level >= 3:
		var enemy_rate = randf()
		if enemy_rate <= 0.3:
			enemy_to_spawn = swarmer_scene
	var new_enemy = enemy_to_spawn.instantiate()
	new_enemy.global_position = spawn_location.global_position
	get_tree().current_scene.add_child(new_enemy)
	new_enemy.tree_exited.connect(on_enemy_died)
	new_enemy.add_to_group("enemy")


func _on_difficulty_timer_timeout() -> void:
	spawn_timer.wait_time = maxf(minimum_spawn_time, spawn_timer.wait_time - 0.1)
	difficulty_level += 1
	
func _on_lineage_broken() -> void:
	is_game_over = true
	await get_tree().create_timer(1.0).timeout
	game_over_menu.appear()
	
func on_enemy_died() -> void:
	score += 1
	hud.update_score(score)
	
func start_boss_fight() -> void:
	spawn_timer.stop()
	var player = get_tree().get_first_node_in_group("player")
	
	is_boss_active = true
	cage_center = player.global_position
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
		
	var cage = cage_scene.instantiate()
	cage.global_position = player.global_position
	get_tree().current_scene.add_child(cage)
	
	var boss = boss_scene.instantiate()
	boss.global_position = player.global_position + Vector2(0,-150)
	get_tree().current_scene.add_child(boss)
