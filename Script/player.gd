extends Node

var max_hp = 0
var curr_hp = 0
@onready var hp_label = $HPLabel  # Adjust the path as needed

func _ready():
	var data = load_json_file("res://data/PC.json")
	var player_stats = get_active_player(data)
	if player_stats:
		hp_label.text = "%d / %d" % [player_stats.curr_hp, player_stats.max_hp]

func load_json_file(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var text = file.get_as_text()
		var parsed = JSON.parse_string(text)
		if parsed:
			return parsed
	return []

func get_active_player(data: Array) -> Dictionary:
	if data.size() == 0:
		return {}
	var characters = data[0]  # Grab the dictionary inside the array
	for key in characters.keys():
		var char = characters[key]
		if char.get("active_player", false):
			return char
	return {}
