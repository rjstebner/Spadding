extends Control

# Constants for cell size
const CELL_SIZE = Vector2i(175, 175)  # Size of each cell (e.g., 64x64)

# Grid dimensions
const GRID_WIDTH = 4
const GRID_HEIGHT = 4

# 2D array to track which grid cells are occupied
var occupied = []

func _ready():
	# Initialize the occupied grid with null (no items placed initially)
	for x in range(GRID_WIDTH):
		occupied.append([])
		for y in range(GRID_HEIGHT):
			occupied[x].append(null)

# Helper function to calculate the position of a cell
func get_cell_position(grid_pos: Vector2i) -> Vector2:
	return global_position + Vector2(grid_pos * CELL_SIZE)

# Check if an item can be placed at a specific grid position
func can_place_item(item, grid_pos: Vector2i) -> bool:
	for offset in item.get_shape_cells():
		var cell = grid_pos + Vector2i(offset)
		if cell.x < 0 or cell.y < 0 or cell.x >= GRID_WIDTH or cell.y >= GRID_HEIGHT:
			return false
		if occupied[cell.x][cell.y] != null:
			return false
	return true

# Place an item on the grid if it fits and snap it to the grid
func place_item(item, grid_pos: Vector2i) -> bool:
	if not can_place_item(item, grid_pos):
		return false

	# Clear the previous position in the occupied grid
	if item.current_grid_pos != Vector2i(-1, -1):
		for offset in item.get_shape_cells():
			var prev_cell = item.current_grid_pos + Vector2i(offset)
			occupied[prev_cell.x][prev_cell.y] = null

	# Snap item to new position
	item.position = get_cell_position(grid_pos)
	item.z_index = 1

	# Mark new occupied cells
	for offset in item.get_shape_cells():
		var cell = grid_pos + Vector2i(offset)
		occupied[cell.x][cell.y] = item

	item.current_grid_pos = grid_pos
	return true

func clear_all_occupied_cells() -> void:
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			occupied[x][y] = null
			
# Draw the grid for debugging
func _draw():
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			var top_left = Vector2i(x, y) * CELL_SIZE
			draw_rect(Rect2(top_left, CELL_SIZE), Color(1, 1, 1, 0.2), false)  # Draw grid lines
