extends Button

var is_overlapping = false  # Tracks if there is an overlapping collision shape
var rune_type: String = "default"  # Type of item
var start_number_grid_button: Button

func _ready() -> void:
	# Connect the Area2D signals
	self.connect("pressed", Callable(self, "_on_button_pressed"))

	start_number_grid_button = get_node("../../StartNumberGrid")
	start_number_grid_button.connect("pressed", Callable(self, "_on_start_number_grid_pressed"))

	# Set the initial color
	update_button_color()

func _on_start_number_grid_pressed() -> void:
    # Check for overlapping areas and update rune_type
	var overlapping_areas = $Area2D.get_overlapping_areas()
	if overlapping_areas.size() > 0:
		var area_owner = overlapping_areas[0].get_owner()
		if area_owner != null and area_owner.has_method("get_rune_type"):
			rune_type = area_owner.get_rune_type()
		else:
			rune_type = "default"
	else:
		rune_type = "default"

	update_button_color()




func _on_button_pressed() -> void:
	var parent_node = get_parent()
	
	if parent_node.active_buttons.has(self):
		parent_node.active_buttons.erase(self)
		modulate = Color(1, 1, 1)  # Reset color to default
	else:
		parent_node.active_buttons[self] = {
			"rune_type": rune_type,
			"number": int(text)
		}
		modulate = Color(0, 1, 0)  # Change color to indicate selection

# Detrimines the Color and rune_type of the button
func update_button_color() -> void:
	# replace modualte with image later
	# string in number will be used to set the image and the value when its time to math

	if rune_type == "default":
			set_button_number([1, 2, 3, 4, 5, 6, 7, 8, 9])  
			modulate = Color(1, 1, 1) 
		
	elif rune_type == "attack":
			set_button_number([1, 2, 3, 4, 5, 6, 7, 8, 9]) 
			modulate = Color(1, 0, 0)
			print("Button change is happending ", rune_type, " ", modulate)

		
	elif rune_type == "defend":
			set_button_number([1, 2, 3, 4, 5, 6, 7, 8, 9])  
			modulate = Color(1, 1, 0)  
	
	else:
		modulate = Color(1, 1, 1) 

		set_button_number([1, 2, 3, 4, 5, 6, 7, 8, 9])  


#chooses from the array and sets the button number
func set_button_number(possible_numbers: Array) -> void:
	randomize()
	var random_index = randi() % possible_numbers.size()  
	text = str(possible_numbers[random_index])  
