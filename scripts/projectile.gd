extends Area2D

var speed: float
var damage: float

func _process(delta: float) -> void:
	global_position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("enemy") and not body.is_in_group("boss"):
		return
	for child in body.get_children():
		if child is HealthComponent:
			child.take_damage(damage)
			queue_free()

func _on_timer_timeout() -> void:
	queue_free()
