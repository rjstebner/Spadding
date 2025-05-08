extends Node

var activeButtons = []
var goal_text = 0
var buttonNode = null
var Goal = null
var streakLabel = null
var streak = 0
var loseLabel = null
var loseTimer = null
var loseTimerNum = 15.0
var highScoreLabel = null
var highScore = 0

func _ready() -> void:


	streakLabel = get_node("/root/Node2D/StreakImage/Streak")
	loseLabel = get_node("/root/Node2D/LoseImage")
	loseTimer = get_node("/root/Node2D/goButton/LoseTimer")
	highScoreLabel = get_node("/root/Node2D/HighScoreImage/HighScore")
	
	load_high_score()
	highScoreLabel.text = "High Score:\n" + str(highScore)
	# Goal text is set in goal mode, since this needs to be set after the goal is set
	# we use call_deferred to ensure this runs after the goal is set
	# This is a workaround for the fact that _ready() is called before the goal is set
	call_deferred("_initialize_text")

	connect("pressed", Callable(self, "_on_button_pressed"))
	loseTimer.connect("timeout", Callable(self, "_on_timer_timeout"))




func _initialize_text() -> void:
	Goal = get_node("../Goal")

	# Retrieve the text property from the Goal node
	goal_text = Goal.text
	
	# Check if the text is empty
	if goal_text == "":
		print("Goal is empty")

	goal_text = int(goal_text)


func _on_button_pressed() -> void:
	# Get the button that was pressed
	var total = 0
	for button in activeButtons:
		total += int(button.buttNum)
	print("Total: ", total)
	print("Goal: ", goal_text)

	if total == goal_text:
		for button in activeButtons:
			button.set_random_number()
			button._set_button_style(true)
		Goal.set_random_number()
		_initialize_text()
		activeButtons.clear()
		streak += 1
		streakLabel.text = "Current Streak\n" + str(streak)
		loseTimerNum = loseTimerNum - 0.5
		loseTimer.start(loseTimerNum)

		$VictorySound.play()
	else:
		$FailSound.play()
		you_lose()

func _on_timer_timeout() -> void:
	
	_on_button_pressed()
		
	
			


func you_lose() -> void:
	loseLabel.visible = true
	loseTimer.stop()
	loseTimerNum = 15.0
	if streak > highScore:
		highScore = streak
		highScoreLabel.text = "High Score \n" + str(highScore)
		save_high_score()
	streak = 0
	streakLabel.text = "Current Streak\n" + str(streak)
	for button in activeButtons:
		button.set_random_number()
		button._set_button_style(true)

	activeButtons.clear()
	Goal.set_random_number()
	_initialize_text()

func load_high_score() -> void:
	if FileAccess.file_exists("user://high_score.save"):
		var file = FileAccess.open("user://high_score.save", FileAccess.READ)
		if file:
			highScore = int(file.get_line())

func save_high_score() -> void:
	var file = FileAccess.open("user://high_score.save", FileAccess.WRITE)
	if file:
		file.store_line(str(highScore))
