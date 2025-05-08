extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func update_score_display(attack_score: int, defend_score: int, joy_score: int, poison_score: int, weak_score: int, vul_score: int, freeze_score: int, haste_score: int) -> void:
    # Update the score display with the provided scores
	var score_label_array = get_tree().get_nodes_in_group("Scores")  # Get all nodes in the "score" group
	var visable_labels = []
	
	for i in range(score_label_array.size()):
		var score_label = score_label_array[i]
        
		match score_label.name:
			"AttackScore":
				if attack_score > 0:
					score_label.text = str(attack_score)
					score_label.visible = true
					visable_labels.append(score_label)
				else:
					score_label.visible = false
					visable_labels.erase(score_label)
			"DefendScore":
				if defend_score > 0:
					score_label.text = str(defend_score)
					score_label.visible = true
					visable_labels.append(score_label)
				else:
					score_label.visible = false
					visable_labels.erase(score_label)
			"JoyScore":
				if joy_score > 0:
					score_label.text = str(joy_score)
					score_label.visible = true
					visable_labels.append(score_label)
				else:
					score_label.visible = false
					visable_labels.erase(score_label)
			"PoisonScore":
				if poison_score > 0:
					score_label.text = str(poison_score)
					score_label.visible = true
					visable_labels.append(score_label)
				else:
					score_label.visible = false
					visable_labels.erase(score_label)
			"WeakenScore":
				if weak_score > 0:
					score_label.text = str(weak_score)
					score_label.visible = true
					visable_labels.append(score_label)
				else:
					score_label.visible = false
					visable_labels.erase(score_label)
			"VulnerableScore":
				if vul_score > 0:
					score_label.text = str(vul_score)
					score_label.visible = true
					visable_labels.append(score_label)
				else:
					score_label.visible = false
					visable_labels.erase(score_label)
			"FreezeScore":
				if freeze_score > 0:
					score_label.text = str(freeze_score)
					score_label.visible = true
					visable_labels.append(score_label)
				else:
					score_label.visible = false
					visable_labels.erase(score_label)
			"HasteScore":
				if haste_score > 0:
					score_label.text = str(haste_score)
					score_label.visible = true
					visable_labels.append(score_label)
				else:
					score_label.visible = false
					visable_labels.erase(score_label)
	position_labels(visable_labels)

func position_labels(visible_labels: Array) -> void:
	if visible_labels.is_empty():
		return

	var spacing := 50  # Adjust as needed
	var center_x := size.x / 2
	var center_y := size.y / 2

	for i in range(visible_labels.size()):
		var label: Label = visible_labels[i] as Label
		var offset := (i - (visible_labels.size() - 1) / 2.0) * spacing
		label.position = Vector2(center_x - label.size.x / 2, center_y + offset - label.size.y / 2)
