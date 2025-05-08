extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_target_total(min_total: int, max_total: int) -> int:
	randomize()
	var target_total: int
	target_total = randi() % (max_total - min_total + 1) + min_total
	text = str("Target" + str(target_total))
	
	return target_total
