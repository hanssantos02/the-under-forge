extends Area2D

@export var stats: WeaponStats
@onready var light: PointLight2D = $PointLight2D
@onready var weapon_sprite: Sprite2D = $Sprite2D



func _ready() -> void:
	var tween = create_tween().set_loops()
	var start_y = weapon_sprite.position.y
	var base_energy: float = 3.0
	tween.tween_property(weapon_sprite, "position:y", start_y - 5.0, 1.0).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(light, "energy", base_energy * 0.5, 1.0)
	tween.tween_property(weapon_sprite, "position:y", start_y, 1.0).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(light, "energy", base_energy, 1.0)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.equip_weapon(stats)
		queue_free()
