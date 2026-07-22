extends CharacterBody2D

@export var speed: float = 100.0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()

func _on_health_component_died() -> void:
	print("The Ancestor has fallen!")
