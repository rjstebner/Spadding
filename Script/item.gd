extends Node2D

@export var cell_shape: PackedVector2Array = PackedVector2Array([Vector2(0, 0)])
@export var rune_type: String = "default"  # Type of item
var default_location: Vector2

var is_dragging = false
var offset = Vector2()
var area: Area2D
var grid: Control


func _ready():
	area = $Area2D
	grid = get_tree().get_first_node_in_group("Grid")

	area.input_pickable = true
	area.connect("input_event", Callable(self, "_on_input_event"))
	z_index = -1

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				ActivePiece.set_active_piece(self)  # Set this piece as the active piece
				is_dragging = true
				offset = global_position - get_global_mouse_position()
				clear_current_grid_pos()
			else:
				is_dragging = false
				try_snap_to_grid()

func _process(_delta):
	if ActivePiece.get_active_piece() == self and is_dragging:
		global_position = get_global_mouse_position() + offset

var current_grid_pos: Vector2i = Vector2i(-1, -1)  # Default to an invalid position
func try_snap_to_grid():
	# Convert global position to grid-local position
	
	var local_pos = global_position - grid.global_position + (Vector2(grid.CELL_SIZE) / 2) # use offset to move maybe
	var cell = Vector2i(local_pos / Vector2(grid.CELL_SIZE))

	if grid.can_place_item(self, cell):
		grid.place_item(self, cell)
		current_grid_pos = cell
	else:
		var active_piece = ActivePiece.get_active_piece()
		active_piece.position = active_piece.default_location

func get_rune_type() -> String:
	return rune_type

func get_shape_cells() -> Array:

	return cell_shape 

func clear_current_grid_pos():
	if current_grid_pos != Vector2i(-1, -1):
		for shape_offset in get_shape_cells():
			var cell = current_grid_pos + Vector2i(shape_offset)
			grid.occupied[cell.x][cell.y] = null
		current_grid_pos = Vector2i(-1, -1)
