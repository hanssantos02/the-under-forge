extends CharacterBody2D

@export var speed: float = 100.0
@export var dropped_weapon_scene: PackedScene
@onready var weapon_pivot: Node2D = $WeaponPivot

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()

func _on_health_component_died() -> void:
	var weapon = dropped_weapon_scene.instantiate()
	weapon.stats = weapon_pivot.stats
	weapon.global_position = global_position
	get_tree().current_scene.add_child(weapon)
	queue_free()
	
