extends CanvasLayer

@onready var timer_label: Label = $Control/TimerLabel
@onready var score_label: Label = $Control/ScoreLabel
@onready var dash_label: Label = $Control/DashLabel
@onready var instructions_label: Label = $Control/InstructionsLabel
@onready var respawn_label: Label = $Control/RespawnLabel
@onready var xp_bar: ProgressBar = $Control/XPBar

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(instructions_label, "modulate:a", 0.0, 5.0).set_delay(3.0)

func update_time(formatted_time: String) -> void:
	timer_label.text = formatted_time
	
func update_score(score: int) -> void:
	score_label.text = "SCORE: " + str(score)
	
func update_xp(current: int, maximum: int) -> void:
	if not is_node_ready():
		await ready
	xp_bar.value = current
	xp_bar.max_value = maximum
	
func set_dash_ready(is_ready: bool) -> void:
	if not is_node_ready():
		await ready
	if is_ready:
		dash_label.text = "DASH READY!"
		dash_label.add_theme_color_override("font_color", Color.GREEN)
	else:
		dash_label.text = "COOLDOWN"
		dash_label.add_theme_color_override("font_color", Color.RED)
	
func show_respawn_prompt(show_prompt: bool) -> void:
	if show_prompt:
		respawn_label.pivot_offset = respawn_label.size / 2.0
		respawn_label.scale = Vector2(0.5, 0.5)
		respawn_label.modulate.a = 0.0
		respawn_label.show()
		var tween = create_tween().set_parallel(true)
		tween.tween_property(respawn_label, "scale", Vector2(1.0, 1.0), 1.0).set_trans(Tween.TRANS_BACK)
		tween. tween_property(respawn_label, "modulate:a", 1.0, 1.0)
	else:
		respawn_label.hide()
