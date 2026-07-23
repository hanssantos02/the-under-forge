extends CharacterBody2D

@export var speed: float = 50.0
var player


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()

func _on_health_component_died() -> void:
	queue_free()
