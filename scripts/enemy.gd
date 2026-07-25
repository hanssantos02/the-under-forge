extends CharacterBody2D

@export var speed: float = 50.0
@export var explosion_scene: PackedScene
@onready var flash_rect: ColorRect = $Sprite2D/FlashRect
@onready var hit_sfx: AudioStreamPlayer2D = $HitSFX
var player
var last_direction: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
		if player == null:
			velocity = last_direction * speed
	else:
		var direction = global_position.direction_to(player.global_position)
		last_direction = direction
		velocity = direction * speed
	move_and_slide()
		
func _on_damaged() -> void:
	var tween = create_tween()
	flash_rect.modulate.a = 1.0
	tween.tween_property(flash_rect, "modulate:a", 0.0, 0.15)
	hit_sfx.play()

func _on_health_component_died() -> void:
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()
