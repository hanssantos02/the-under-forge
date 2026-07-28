extends CanvasLayer

@export var player: CharacterBody2D
@onready var upgrade_1: Button = $HBoxContainer/Upgrade1
@onready var upgrade_2: Button = $HBoxContainer/Upgrade2
@onready var upgrade_3: Button = $HBoxContainer/Upgrade3
@onready var legacy_label: Label = $ColorRect/LegacyLabel
@onready var description_label: Label = $ColorRect/DescriptionLabel
var upgrade_pool: Array = [{"id": "proj_speed", "title": "Swift Shot", "description": "Increases projectile flight speed."},
							{ "id": "damage", "title": "Heavy Rounds", "description": "Increases projectile damage."},
							{ "id": "fire_rate", "title": "Rapid Fire", "description": "Increases weapon fire rate."},
							{ "id": "player_speed", "title": "Fleet Foot", "description": "Increases player movement speed."},
							{ "id": "player_dash_speed", "title": "Quick Step", "description": "Increases dash speed."}]
var current_choices: Array = []

func apply_upgrade(upgrade_id: String) -> void:
	match upgrade_id:
		"proj_speed":
			player.weapon_pivot.stats.projectile_speed += 50.0
		"damage":
			player.weapon_pivot.stats.damage += 5.0
		"fire_rate":
			player.weapon_pivot.stats.fire_rate = maxf(0.2, player.weapon_pivot.stats.fire_rate - 0.2)
			player.weapon_timer.wait_time = player.weapon_pivot.stats.fire_rate
		"player_speed":
			player.speed += 20.0
		"player_dash_speed":
			player.dash_speed += 30.0
	get_tree().paused = false
	hide()


func _on_upgrade_1_pressed() -> void:
	apply_upgrade(current_choices[0]["id"])

func _on_upgrade_2_pressed() -> void:
	apply_upgrade(current_choices[1]["id"])


func _on_upgrade_3_pressed() -> void:
	apply_upgrade(current_choices[2]["id"])

func setup_menu() -> void:
	current_choices.clear()
	upgrade_pool.shuffle()
	for i in range(3):
		current_choices.append(upgrade_pool[i])
	upgrade_1.text = current_choices[0]["title"]
	upgrade_2.text = current_choices[1]["title"]
	upgrade_3.text = current_choices[2]["title"]
	description_label.text = ""
	
func show_description(choice_index: int) -> void:
	var upgrade_id = current_choices[choice_index]["id"]
	
	var stat_label = ""
	var stat_value = 0.0
	match upgrade_id:
		"proj_speed":
			stat_label = "Current Projectile Speed: "
			stat_value = player.weapon_pivot.stats.projectile_speed
		"damage":
			stat_label = "Current Damage: "
			stat_value = player.weapon_pivot.stats.damage
		"fire_rate":
			stat_label = "Current Fire Rate: "
			stat_value = player.weapon_pivot.stats.fire_rate
		"player_speed":
			stat_label = "Current Player Speed: "
			stat_value = player.speed
		"player_dash_speed":
			stat_label = "Current Dash Speed: "
			stat_value = player.dash_speed
	description_label.text = current_choices[choice_index]["description"] + "\n" + stat_label + str(stat_value)

func _on_upgrade_1_mouse_entered() -> void:
	show_description(0)
	


func _on_upgrade_2_mouse_entered() -> void:
	show_description(1)


func _on_upgrade_3_mouse_entered() -> void:
	show_description(2)
	
func _on_mouse_exit() -> void:
	description_label.text = ""
