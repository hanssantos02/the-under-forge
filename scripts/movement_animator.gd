extends Node

@export var sprite: Sprite2D
@export var character: CharacterBody2D
var time_passed: float = 0.0
var wobble_speed: float = 15.0
var wobble_angle: float = 0.15
var hop_height: float = 3.0

func _process(delta: float) -> void:
	if character.velocity.length() > 0:
		time_passed += delta
		var wave = sin(time_passed * wobble_speed)
		sprite.rotation = wave * wobble_angle
		sprite.position.y = abs(wave) * -hop_height
	else:
		time_passed = 0.0
		sprite.rotation = lerpf(sprite.rotation, 0.0, 10.0 * delta)
		sprite.position.y = lerpf(sprite.position.y, 0.0, 10.0 * delta)
