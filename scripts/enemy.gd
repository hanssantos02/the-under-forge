extends CharacterBody2D

@export var speed: float = 50.0
var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta: float) -> void:
	if player != null:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
