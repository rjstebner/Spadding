extends Node

var player
var runes_from_player
var runes: Array = []
var main: Node2D #Rename later

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_parent().get_parent()
	print(main)
	call_deferred("_init_runes")

func _on_attack_button_pressed() -> void:
	button_pressed("attack")

func _on_defend_button_pressed() -> void:
	button_pressed("defend")


func button_pressed(rune_type: String) -> void:
	for rune in runes:
		if rune.get_rune_type() == rune_type:
			print(rune_type)
			rune.visible = true
		else:
			if rune.position == rune.default_location:
				rune.visible = false
			else:
				rune.visible = true



# Called when the node enters the scene tree for the first time.
func get_runes_from_player() -> void:
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().has_group("player") else null
	runes_from_player = player.runes
	print(runes_from_player)
	instantiate_runes()


# Called every frame. 'delta' is the elapsed time since the previous frame.

func instantiate_runes():
	for rune_path in runes_from_player:
		var rune_scene = load(rune_path)
		if rune_scene:
			var rune_instance = rune_scene.instantiate()
			rune_instance.add_to_group("Rune")
			main.add_child(rune_instance)
			set_rune_default_location(rune_instance)

func _init_runes():
	get_runes_from_player()
	

	runes = get_tree().get_nodes_in_group("Rune")
	for rune in runes:
		rune.position = rune.default_location

	$AttackBTN.connect("pressed", Callable(self, "_on_attack_button_pressed"))
	$DefendBTN.connect("pressed", Callable(self, "_on_defend_button_pressed"))

	_on_attack_button_pressed()

func set_rune_default_location(rune_instance: Node2D) -> void:
	# make dynamic layer
	if rune_instance.has_method("set"):
		rune_instance.set("default_location", Vector2(1000, 100))
