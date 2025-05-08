extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var num = randi_range(10, 40)
	
	text = str(num)

func set_random_number() -> void:
	randomize()
	var num = randi_range(10, 40)
	text = str(num)


