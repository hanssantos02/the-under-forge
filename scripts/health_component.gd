extends Node
class_name HealthComponent

signal died
signal damaged

@export var max_health: float = 10.0
var current_health
var is_invincible: bool = false

func _ready() -> void:
	current_health = max_health
	
func take_damage(amount: float) -> void:
	if is_invincible:
		return
	damaged.emit()
	current_health -= amount
	if current_health <= 0:
		died.emit()
