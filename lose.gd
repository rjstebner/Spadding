extends TextureRect
# This script is attached to a TextureRect node in Godot

# Called when an input event is detected
func _input(event: InputEvent) -> void:
    if event.is_pressed():  # Check if any input event is pressed
        visible = false  # Make the label invisible