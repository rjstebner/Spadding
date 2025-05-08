extends Button

var active_buttons: Dictionary = {}  # Dictionary to track active buttons, comes from number_panel.gd in ready
var number_panel: Control

# This is the target total label and target total int
var target_total_label: Label
var target_total: int = 0 

# This is what will display the different types of scores
var score_label_array: Array = []  

# This is the score for each type of score
var score_tracker: Node = null  # Reference to the score display node
var attack_score: int = 0
var defend_score: int = 0
var joy_score: int = 0
var poison_score: int = 0
var weak_score: int = 0
var vul_score: int = 0
var freeze_score: int = 0
var haste_score: int = 0

# This the the total some of the active buttons
var active_buttons_total: int = 0

# This is used to give the player a time crunch
var timer
var timer_default_duration = 15.0
var timer_duration = 15.0

# CombatManager
var combat_manager: Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Set nodes to variables
	number_panel = get_node("../NumberPanel")
	target_total_label = get_node("../TargetTotal")
	score_tracker = get_node("../ScoreTracker")  
	timer = get_node("../Timer")
	combat_manager = get_node("../../CombatManager")
	
	# Connect the button pressed signal to the function
	connect("pressed", Callable(self, "_on_button_pressed"))
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	#Sets the total lable with the function and the target total int with the return part
	randomize_target(10, 40)
	score_label_array = get_tree().get_nodes_in_group("Scores")  # Get all nodes in the "score" group



func _on_button_pressed() -> void:
	# Gets the active buttons from the number panel
	timer.start(timer_duration)
	active_buttons = number_panel.get_active_buttons()

	# adds the scores together and displays them
	calculate_scores()

	# Checks for Victory or Defeat
	if active_buttons_total == int(target_total):
		victory()
	else:
		defeat()

	# Reset scores and displays to 0

	# Reset the number buttons
	reset_buttons()
	number_panel.active_buttons = {}
	active_buttons = {}

		
func calculate_scores() -> void:
	# Calculate the scores based on the active buttons
	active_buttons = number_panel.get_active_buttons()
	active_buttons_total = 0
	
	for data in active_buttons.values():
		print("Type of number:", typeof(data["number"]), " Value:", data["number"])
		active_buttons_total += int(data["number"])
		
		match data["rune_type"]:
			"attack":
				attack_score += 1
			"defend":
				defend_score += 1
			"joy":
				joy_score += 1
			"poison":
				poison_score += 1
			"weak":
				weak_score += 1
			"vul":
				vul_score += 1
			"freeze":
				freeze_score += 1
			"haste":
				haste_score += 1

	score_tracker.update_score_display(attack_score, defend_score, joy_score, poison_score, weak_score, vul_score, freeze_score, haste_score)
	#Clear active Buttons

func reset_scores() -> void:
	# Reset all scores to zero
	attack_score = 0
	defend_score = 0
	joy_score = 0
	poison_score = 0
	weak_score = 0
	vul_score = 0
	freeze_score = 0
	haste_score = 0

	active_buttons_total = 0

	# Update the score labels with the new values
	score_tracker.update_score_display(attack_score, defend_score, joy_score, poison_score, weak_score, vul_score, freeze_score, haste_score)

func reset_buttons() -> void:
	# Reset all buttons to their default state
	for button in active_buttons.keys():
		button.modulate = Color(1, 1, 1)  # Reset color to default
		button.set_button_number([1, 2, 3, 4, 5, 6, 7, 8, 9])  # Reset button number to default

func victory() -> void:
	print("You win!")
	timer_duration -= 0.5
	timer.start(timer_duration)
	randomize_target(10,40)
	# Set timer

func defeat() -> void:
	# This function is called when the player loses
	print("You lose!")
	# Disable the number Panel and reset rune postion
	#play animation
	#when animation finshed
	number_panel.visible = false
	var _runes = get_tree().get_nodes_in_group("Rune")  # Retrieve nodes in the "Runes" group
	var rune_page = get_node("../RunePage")
	for rune in _runes:
		if rune.position != rune.default_location:
			rune.position = rune.default_location
	rune_page.button_pressed("attack")
	var item_grid = get_node("../../ItemGrid")
	item_grid.clear_all_occupied_cells()
	
	timer_duration = timer_default_duration

	send_scores_to_combat()
	#combat_manager.start_turn()
	reset_scores()


func _on_timer_timeout() -> void:
		defeat()

func randomize_target(target_min: int, target_max: int) -> void:
	target_total = target_total_label.set_target_total(target_min, target_max)

func send_scores_to_combat() -> void:
	var scores = [
		attack_score,
		defend_score,
		joy_score,
		poison_score,
		weak_score,
		vul_score,
		haste_score,
		freeze_score
    ]
	combat_manager.scores = scores