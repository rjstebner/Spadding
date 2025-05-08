extends Node

var active_piece: Node2D = null

func set_active_piece(piece: Node2D):
    if active_piece:
        active_piece.is_dragging = false  # Stop dragging the previous piece
    active_piece = piece

func get_active_piece() -> Node2D:
    return active_piece