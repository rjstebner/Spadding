extends Node

var runes: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	runes = get_tree().get_nodes_in_group("Rune")
	for rune in runes:
		rune.position = rune.default_location

	$AttackBTN.connect("pressed", Callable(self, "_on_attack_button_pressed"))
	$DefendBTN.connect("pressed", Callable(self, "_on_defend_button_pressed"))

	_on_attack_button_pressed()

func _on_attack_button_pressed() -> void:
	button_pressed("attack")

func _on_defend_button_pressed() -> void:
	button_pressed("defend")


func button_pressed(rune_type: String) -> void:
	for rune in runes:
		if rune.get_rune_type() == rune_type:
			rune.visible = true
		else:
			if rune.position == rune.default_location:
				rune.visible = false
			else:
				rune.visible = true