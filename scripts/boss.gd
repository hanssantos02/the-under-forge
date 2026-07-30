extends CharacterBody2D

signal boss_died

enum State { CHASE, WINDUP, CHARGE }

@export var speed: float = 50.0
@export var charge_speed: float = 150.0
@export var swarmer_scene: PackedScene
@export var projectile_scene: PackedScene
@export var xp_gem_scene: PackedScene
@export var explosion_scene: PackedScene

@onready var state_timer: Timer = $StateTimer
@onready var warning_line: Line2D = $WarningLine
@onready var health_component: HealthComponent = $HealthComponent
@onready var flash_rect: ColorRect = $Sprite2D/FlashRect
@onready var hit_sfx: AudioStreamPlayer2D = $HitSFX

var current_state: State = State.CHASE
var charge_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	warning_line.clear_points()
	warning_line.add_point(Vector2.ZERO)
	warning_line.add_point(Vector2.ZERO)
	warning_line.default_color = Color.RED
	warning_line.hide()


func _on_state_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	
	if player != null:
		match current_state:
			State.CHASE:
				current_state = State.WINDUP
				warning_line.show()
				state_timer.wait_time = 1.0
				state_timer.start()
			State.WINDUP:
				current_state = State.CHARGE
				charge_direction = global_position.direction_to(player.global_position)
				warning_line.hide()
				state_timer.wait_time = 0.5
				state_timer.start()
			State.CHARGE:
				current_state = State.CHASE
				spawn_attacks()
				state_timer.wait_time = 5.0
				state_timer.start()
			
func _physics_process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	
	if player != null:
		match current_state:
			State.CHASE:
				var direction = global_position.direction_to(player.global_position)
				velocity = direction * speed
			State.WINDUP:
				velocity = Vector2.ZERO
				warning_line.set_point_position(1, warning_line.to_local(player.global_position))
				warning_line.modulate.a = 0.5
			State.CHARGE:
				velocity = charge_direction * charge_speed
				
	move_and_slide()
	
func spawn_attacks() -> void:
	for i in range(2):
		var swarmer = swarmer_scene.instantiate()
		swarmer.global_position = global_position + Vector2(randf_range(-30, 30), randf_range(-30, 30))
		get_tree().current_scene.call_deferred("add_child", swarmer)
		swarmer.add_to_group("enemy")
		
	for i in range(8):
		var angle_degrees = i * 45.0
		var angle_radians = deg_to_rad(angle_degrees)
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		projectile.rotation = angle_radians
		get_tree().current_scene.call_deferred("add_child", projectile)
		
func _on_damaged() -> void:
	var tween = create_tween()
	flash_rect.modulate.a = 1.0
	tween.tween_property(flash_rect, "modulate:a", 0.0, 0.15)
	hit_sfx.play()


func _on_health_component_died() -> void:
	boss_died.emit()
	
	for i in range(15):
		var xp_gem = xp_gem_scene.instantiate()
		xp_gem.global_position = global_position + Vector2(randf_range(-40, 40), randf_range(-40, 40))
		get_tree().current_scene.call_deferred("add_child", xp_gem)
		
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", explosion)
	
	queue_free()
