extends Area2D

var target = null
@export var fly_speed: float = 200.0
@export var xp_amount: int = 1

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("gain_xp"):
		if body.has_weapon == true:
			body.gain_xp(xp_amount)
			queue_free()

func fly_towards(node) -> void:
	target = node
	
func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, fly_speed * delta)
