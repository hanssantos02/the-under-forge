extends Node2D

@export var projectile_scene: PackedScene
@export var stats: WeaponStats
@onready var muzzle_point: Marker2D = $WeaponSprite/MuzzlePoint
@onready var weapon_timer: Timer = $WeaponTimer


func _ready() -> void:
	weapon_timer.wait_time = stats.fire_rate

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())


func _on_timer_timeout() -> void:
	var projectile = projectile_scene.instantiate()
	projectile.speed = stats.projectile_speed
	projectile.damage = stats.damage
	projectile.global_position = muzzle_point.global_position
	projectile.global_rotation = global_rotation
	get_tree().current_scene.add_child(projectile)
