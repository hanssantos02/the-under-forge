extends Area2D

@export var speed: float = 300.0


func _process(delta: float) -> void:
	global_position += transform.x * speed * delta
