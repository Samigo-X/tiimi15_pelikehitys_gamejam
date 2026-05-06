extends RefCounted
class_name BoardLogic

const COLS = 10
const ROWS = 20
const BOARD_OFFSET = Vector2i(1, 1)

var board_layer: TileMapLayer

func _init(new_board_layer: TileMapLayer):
	board_layer = new_board_layer

func board_pos(pos: Vector2i) -> Vector2i:
	return BOARD_OFFSET + pos

func is_valid_position(pos: Vector2i) -> bool:
	if pos.x < 0 or pos.x >= COLS or pos.y < 0 or pos.y >= ROWS:
		return false
	
	return board_layer.get_cell_source_id(board_pos(pos)) == -1

func lock_blocks(position: Vector2i, blocks: Array, piece_atlas: Vector2i):
	for block in blocks:
		board_layer.set_cell(board_pos(position + block), 0, piece_atlas)

func clear_full_rows() -> int:
	var cleared_this_turn := 0
	var row = ROWS - 1
	
	while row >= 0:
		if is_row_full(row):
			clear_row(row)
			drop_rows_above(row)
			cleared_this_turn += 1
		else:
			row -= 1
	
	return cleared_this_turn

func is_row_full(row: int) -> bool:
	for col in range(COLS):
		if board_layer.get_cell_source_id(board_pos(Vector2i(col, row))) == -1:
			return false
	return true

func clear_row(row: int):
	for col in range(COLS):
		board_layer.set_cell(board_pos(Vector2i(col, row)), -1)

func drop_rows_above(row: int):
	for r in range(row - 1, -1, -1):
		for col in range(COLS):
			var from_pos = board_pos(Vector2i(col, r))
			var to_pos = board_pos(Vector2i(col, r + 1))

			var source = board_layer.get_cell_source_id(from_pos)
			var atlas = board_layer.get_cell_atlas_coords(from_pos)

			if source != -1:
				board_layer.set_cell(to_pos, source, atlas)
			else:
				board_layer.set_cell(to_pos, -1)

	for col in range(COLS):
		board_layer.set_cell(board_pos(Vector2i(col, 0)), -1)
