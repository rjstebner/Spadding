extends Node2D

var goButton
# scores are being sent by the go button
var scores
var player
var enemy
var target
var current_action

func _ready() -> void:

	player = $Player
	enemy = $Enemy
	# incase I need it 
	#goButton = get_node("../GamePlayPanel/GoButton")
	get_enemy_action()



func start_turn():
	print("turn starting")
	
	#Set player as target for sheild
	set_target(1)
	
	gain_shield(scores[1])
	update_labels()
	await delay(1)
	
	#set enemy as target then continue
	set_target(0)

	deal_damage(scores[0])
	update_labels()
	await delay(1)
		#remeber to consider joy and vul

	#player applies joy
	#player applies poison
	#player applies weak
	#player applies vul
	#player freezes
		#remeber increase freeze threshold

	#enemy turn 
	# set sheild to 0
	if enemy.shield != 0:
		enemy.shield = 0
	
	# Choose action
	do_enemy_action()
	get_enemy_action()
	update_labels()
	await delay(1)

	# set sheild to 0
	if player.shield != 0:
		player.shield = 0



func set_target(value: int):
	if value == 0:
		target = enemy
	else:
		target = player

func deal_damage(value: int ):
	target.shield -= value
	if target.shield <= 0:
		target.curr_hp += target.shield

func gain_shield(value: int):
	target.shield += value

func get_enemy_action():
	var roll = float(randi() % 10) # a random number between 1 and 10
	for action in enemy.actions:
		if roll in action["chance"]:
			current_action = action
	display_enemy_action()

func do_enemy_action():
	for type in current_action["type"]:
		match type:
			"attack": 
				deal_damage(int(current_action["damage"]))
			"shield": 
				set_target(0)
				gain_shield(int(current_action["shield"]))


func delay(seconds: float):
	await get_tree().create_timer(seconds).timeout


func update_labels():
	if player.shield > 0:
		player.get_node("HPLabel").text = "Shield " + str(player.shield)
		player.get_node("HPLabel").modulate = Color(1, 1, 0)
	else:
		player.get_node("HPLabel").text = "HP " + str(player.curr_hp) + " / " + str(player.max_hp)
		if player.curr_hp < 0:
			player.get_node("HPLabel").modulate = Color(1, 0, 0)
		else:
			player.get_node("HPLabel").modulate = Color(0, 1, 0)
	
	if enemy.shield > 0:
		enemy.get_node("HPLabel").text = "Shield " + str(enemy.shield)
		enemy.get_node("HPLabel").modulate = Color(1, 1, 0)
	else:
		enemy.get_node("HPLabel").text = "HP " + str(enemy.curr_hp) + " / " + str(enemy.max_hp)
		if enemy.curr_hp < 0:
			enemy.get_node("HPLabel").modulate = Color(1, 0, 0)
		else:
			enemy.get_node("HPLabel").modulate = Color(0, 1, 0)

func display_enemy_action():
	var intention = enemy.get_node("Plan")
	intention.text = ""
	for type in current_action["type"]:
		match type:
			"attack": 
				intention.text += "\n Attacking: " + str(current_action["damage"])
			"shield": 
				intention.text += "\n Defending: " + str(current_action["shield"])
