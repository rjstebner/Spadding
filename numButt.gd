extends Button

var activeButtons = []
var buttNum = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_random_number()
	
	var goButton = get_node("/root/Node2D/goButton")
	activeButtons = goButton.activeButtons

	# remeber you have to connect the signal in the editor
	connect("pressed", Callable(self, "_on_button_pressed"))

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_button_pressed() -> void:
	if self in activeButtons:
		activeButtons.erase(self)
		_set_button_style(true)
	else:
		activeButtons.append(self)
		_set_button_style(false)
	
	$PressSound.play()

func _set_button_style(is_active: bool) -> void:	
	if is_active:
        # Add a custom style override to remove the default grey box
		add_theme_stylebox_override("normal", StyleBoxEmpty.new())
		modulate = Color(1, 1, 1, 1)
	else:
        # Remove the custom style override to restore the default grey box
		remove_theme_stylebox_override("normal")
		modulate = Color(0, 255, 0, .25)


func set_random_number() -> void:
	randomize()
	var num = randi_range(1, 9)
	# Set the text of the button to a random number between 1 and 9
	buttNum = num
	_set_icon(num)


func _set_icon(num: int) -> void:
	# Set the icon based on the number
	match num:
		1:
			icon = preload("res://numberBlocks/1 block.png")
		2:
			icon = preload("res://numberBlocks/2 block.png")
		3:
			icon = preload("res://numberBlocks/3 block.png")
		4:
			icon = preload("res://numberBlocks/4 block.png")
		5:
			icon = preload("res://numberBlocks/5 block.png")
		6:
			icon = preload("res://numberBlocks/6 block.png")
		7:
			icon = preload("res://numberBlocks/7 block.png")
		8:
			icon = preload("res://numberBlocks/8 block.png")
		9:
			icon = preload("res://numberBlocks/9 block.png")
