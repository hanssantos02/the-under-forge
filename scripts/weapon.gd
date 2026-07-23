extends Node2D

@export var projectile_scene: PackedScene
@onready var muzzle_point: Marker2D = $WeaponSprite/MuzzlePoint

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())


func _on_timer_timeout() -> void:
	var projectile = projectile_scene.instantiate()
	projectile.global_position = muzzle_point.global_position
	projectile.global_rotation = global_rotation
	get_tree().current_scene.add_child(projectile)
