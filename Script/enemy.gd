extends Node2D

@onready var hp_label = $HPLabel

var max_hp
var curr_hp
var shield: int
var actions: Array

func _ready():
	randomize()
	var enemy = get_random_enemy_from_location("00")
	if enemy.size() > 0:  # Use size() to check if a dictionary is not empty
		print("You encountered a %s!" % enemy["name"])
		hp_label.text = "%d / %d" % [enemy["health"], enemy["health"]]
		hp_label.modulate = Color(0,1,0)
	max_hp = int(enemy.health)
	curr_hp = max_hp
	if enemy.has("actions"):
		actions = enemy["actions"]

func get_random_enemy_from_location(location_code: String) -> Dictionary:
	var enemies = load_json_file("res://data/monsters.json")
	var matching_enemies = []

	for enemy in enemies:
		if enemy.get("location") == location_code:
			matching_enemies.append(enemy)

	if matching_enemies.size() > 0:
		return matching_enemies[randi() % matching_enemies.size()]
	return {}

func load_json_file(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var text = file.get_as_text()
		var parsed = JSON.parse_string(text)
		if parsed:
			return parsed
	return []