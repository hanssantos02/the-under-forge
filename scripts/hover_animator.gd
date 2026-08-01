extends Node

@export var target: CanvasItem
@export var hover_speed: float = 2.0
@export var hover_distance: float = 10.0
var time_passed: float
var start_y: float

func _ready() -> void:
	if target != null:
		start_y = target.position.y
		
func _process(delta: float) -> void:
	if target != null:
		time_passed += delta
		var wave = sin(time_passed * hover_speed)
		target.position.y = start_y + (wave * hover_distance)
