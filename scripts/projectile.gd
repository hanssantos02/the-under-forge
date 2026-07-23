extends Area2D

var speed: float
var damage: float

func _process(delta: float) -> void:
	global_position += transform.x * speed * delta
