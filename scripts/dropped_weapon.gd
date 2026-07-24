extends Area2D

@export var stats: WeaponStats

func _ready() -> void:
	var tween = create_tween().set_loops()
	var start_y = position.y
	tween.tween_property(self, "position:y", start_y - 5.0, 1.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", start_y, 1.0).set_trans(Tween.TRANS_SINE)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.equip_weapon(stats)
		queue_free()
