extends Node2D

const COLS = 10
const ROWS = 20
const CELL_SIZE = 32
const BOARD_OFFSET = Vector2i(1, 1)

const GRID_COLOR = Color("#2f3f4f80")
const GRID_BORDER_COLOR = Color("#77d9ff")
const BOARD_BG_COLOR = Color("#05070d")

func _draw():
	var top_left = Vector2(BOARD_OFFSET * CELL_SIZE)
	var board_size = Vector2(COLS * CELL_SIZE, ROWS * CELL_SIZE)
	
	draw_rect(Rect2(top_left, board_size), BOARD_BG_COLOR, true)
	
	for col in range(COLS + 1):
		var x = top_left.x + col * CELL_SIZE
		draw_line(
			Vector2(x, top_left.y),
			Vector2(x, top_left.y + board_size.y),
			GRID_COLOR,
			1
		)
	
	for row in range(ROWS + 1):
		var y = top_left.y + row * CELL_SIZE
		draw_line(
			Vector2(top_left.x, y),
			Vector2(top_left.x + board_size.x, y),
			GRID_COLOR,
			1
		)
	
	draw_rect(Rect2(top_left, board_size), GRID_BORDER_COLOR, false, 2)
