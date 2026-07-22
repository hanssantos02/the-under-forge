extends Area2D

@export var damage: float = 10.0

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	for child in body.get_children():
		if child is HealthComponent:
			child.take_damage(damage)
