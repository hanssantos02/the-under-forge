extends CharacterBody2D

enum State { CHASE, WINDUP, CHARGE }

@export var speed: float = 50.0
@export var charge_speed: float = 150.0
@export var swarmer_scene: PackedScene


@onready var state_timer: Timer = $StateTimer
@onready var warning_line: Line2D = $WarningLine
@onready var health_component: HealthComponent = $HealthComponent

var current_state: State = State.CHASE
var charge_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	warning_line.clear_points()
	warning_line.add_point(Vector2.ZERO)
	warning_line.add_point(Vector2.ZERO)
	warning_line.default_color = Color.RED
	warning_line.hide()


func _on_state_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		match current_state:
			State.CHASE:
				current_state = State.WINDUP
				warning_line.show()
				state_timer.wait_time = 1.0
				state_timer.start()
			State.WINDUP:
				current_state = State.CHARGE
				charge_direction = global_position.direction_to(player.global_position)
				warning_line.hide()
				state_timer.wait_time = 0.5
				state_timer.start()
			State.CHARGE:
				current_state = State.CHASE
				state_timer.wait_time = 3.0
				state_timer.start()
			
func _physics_process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		match current_state:
			State.CHASE:
				var direction = global_position.direction_to(player.global_position)
				velocity = direction * speed
			State.WINDUP:
				velocity = Vector2.ZERO
				warning_line.set_point_position(1, warning_line.to_local(player.global_position))
				warning_line.modulate.a = 0.5
			State.CHARGE:
				velocity = charge_direction * charge_speed
	move_and_slide()
