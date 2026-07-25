extends CharacterBody2D

@export var speed: float = 100.0
@export var dropped_weapon_scene: PackedScene
@onready var weapon_pivot: Node2D = $WeaponPivot
@onready var camera_2d: Camera2D = $Camera2D
@export var has_weapon: bool = true
@onready var weapon_timer: Timer = $WeaponPivot/WeaponTimer

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

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
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
	
