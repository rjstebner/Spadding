extends Control

var startNumberButton: Button
var active_buttons: Dictionary = {}  # Dictionary to track active buttons, comes from numberbutton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	startNumberButton = get_node("../StartNumberGrid")
	startNumberButton.connect("pressed", Callable(self, "_turn_number_panel_on"))
	z_index = 2
func _turn_number_panel_on() -> void:
	self.visible = true

func get_active_buttons() -> Dictionary:
	# This function returns the active buttons
	return active_buttons