extends CharacterBody2D

@export var speed: float = 100.0
@export var dropped_weapon_scene: PackedScene
@export var has_weapon: bool = true
@export var dash_speed: float = 400.0
@onready var weapon_pivot: Node2D = $WeaponPivot
@onready var camera_2d: Camera2D = $Camera2D
@onready var weapon_timer: Timer = $WeaponPivot/WeaponTimer
@onready var pickup_sfx: AudioStreamPlayer = $PickupSFX
@onready var dash_duration_timer: Timer = $DashDurationTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var dash_sfx: AudioStreamPlayer = $DashSFX
@onready var upgrade_menu: CanvasLayer = $UpgradeMenu
@onready var gem_sfx: AudioStreamPlayer = $GemSFX

var is_dashing: bool = false
var can_dash: bool = true
var dash_direction: Vector2 = Vector2.ZERO
var experience: int = 0
var level: int = 1
var exp_to_next_level: int = 5

func _ready() -> void:
	if not has_weapon:
		weapon_pivot.hide()
		weapon_timer.stop()
	camera_2d.make_current()
	
func equip_weapon(new_stats: WeaponStats) -> void:
	weapon_pivot.stats = new_stats
	weapon_pivot.show()
	weapon_timer.start()
	weapon_pivot.update_appearance()
	has_weapon = true
	pickup_sfx.play()

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_just_pressed("dash") and can_dash and direction != Vector2.ZERO:
		is_dashing = true
		can_dash = false
		dash_direction = direction
		dash_duration_timer.start()
		dash_cooldown_timer.start()
		health_component.is_invincible = true
		set_collision_mask_value(2, false)
		set_collision_layer_value(1, false)
		dash_sfx.play()
	if is_dashing:
		velocity = dash_direction * dash_speed
	else:
		velocity = direction * speed
	move_and_slide()

func _on_health_component_died() -> void:
	if has_weapon:
		var weapon = dropped_weapon_scene.instantiate()
		weapon.stats = weapon_pivot.stats
		weapon.global_position = global_position
		get_tree().current_scene.add_child(weapon)
		camera_2d.reparent(weapon)
	queue_free()
	
func _on_dash_duration_timer_timeout() -> void:
	is_dashing = false
	health_component.is_invincible = false
	set_collision_mask_value(2, true)
	set_collision_layer_value(1, true)


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
	

func gain_xp(amount: int) -> void:
	experience += amount
	gem_sfx.play()
	if experience >= exp_to_next_level:
		level_up()
		
func level_up() -> void:
	if health_component.current_health <= 0:
		return
	experience -= exp_to_next_level
	level += 1
	exp_to_next_level *= 1.5
	get_tree().paused = true
	upgrade_menu.show()
