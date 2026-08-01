extends CharacterBody2D

signal lineage_broken
signal xp_changed(current: int, maximum: int)
signal dash_status_changed(is_ready: bool)

@export var speed: float = 100.0
@export var dropped_weapon_scene: PackedScene
@export var sacrifice_scene: PackedScene
@export var shatter_scene: PackedScene
@export var has_weapon: bool = true
@export var dash_speed: float = 400.0
@onready var weapon_pivot: Node2D = $WeaponPivot
@onready var character_sprite: Sprite2D = $CharacterSprite
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
var experience: float = 0.0
var level: int = 1
var exp_to_next_level: float = 5.0

func _ready() -> void:
	if not has_weapon:
		weapon_pivot.hide()
		weapon_timer.stop()
	else:
		weapon_pivot.stats = weapon_pivot.stats.duplicate()
	camera_2d.make_current()
	dash_status_changed.emit(true)
	xp_changed.emit(experience, exp_to_next_level)
	
	var tween = create_tween()
	character_sprite.scale = Vector2.ZERO
	weapon_pivot.scale = Vector2.ZERO
	tween.tween_property(character_sprite, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(weapon_pivot, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK)
func equip_weapon(new_stats: WeaponStats) -> void:
	weapon_pivot.stats = new_stats
	weapon_pivot.show()
	weapon_timer.wait_time = new_stats.fire_rate
	weapon_timer.start()
	weapon_pivot.update_appearance()
	has_weapon = true
	
	level = new_stats.level
	exp_to_next_level = new_stats.exp_to_next_level
	xp_changed.emit(experience, exp_to_next_level)
	
	pickup_sfx.play()

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_just_pressed("dash") and can_dash and direction != Vector2.ZERO:
		is_dashing = true
		can_dash = false
		dash_status_changed.emit(false)
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
		get_tree().current_scene.call_deferred("add_child", weapon)
		weapon.add_to_group("dropped_weapon")
		camera_2d.call_deferred("reparent",weapon)
		var sacrifice = sacrifice_scene.instantiate()
		sacrifice.global_position = global_position
		get_tree().current_scene.call_deferred("add_child",sacrifice)
	else:
		var shatter = shatter_scene.instantiate()
		shatter.global_position = global_position
		get_tree().current_scene.call_deferred("add_child",shatter)
		camera_2d.reparent(get_tree().current_scene)
		camera_2d.make_current()
		lineage_broken.emit()
	queue_free()
	
func _on_dash_duration_timer_timeout() -> void:
	is_dashing = false
	health_component.is_invincible = false
	set_collision_mask_value(2, true)
	set_collision_layer_value(1, true)


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
	dash_status_changed.emit(true)
	

func gain_xp(amount: int) -> void:
	experience += amount
	xp_changed.emit(experience, exp_to_next_level)
	gem_sfx.play()
	if experience >= exp_to_next_level:
		level_up()
		
func level_up() -> void:
	if health_component.current_health <= 0:
		return
	experience -= exp_to_next_level
	level += 1
	exp_to_next_level *= 1.5
	
	if has_weapon:
		weapon_pivot.stats.level = level
		weapon_pivot.stats.exp_to_next_level = exp_to_next_level
		
	get_tree().paused = true
	upgrade_menu.setup_menu()
	upgrade_menu.show()

func _on_magnet_area_area_entered(area: Area2D) -> void:
	if area.has_method("fly_towards") and has_weapon:
		area.fly_towards(self)
