extends Area2D

@export var speed: float = 300.0

var direction: Vector2 = Vector2.RIGHT

func _process(delta: float) -> void:
	global_position += direction * speed * delta
