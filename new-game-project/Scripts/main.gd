extends Control

const GRID_WIDTH: int = 10
const GRID_HEIGHT: int = 20
const BLOCK_SIZE: int = 30

var grid: Array[Array] = []
@onready var game_area: ColorRect = $GameArea
@onready var grid_lines: Node2D = $GameArea/GridLines

func _ready() -> void:
	initialize_grid()
	draw_grid_lines()
	
func initialize_grid() -> void:
	for x in range(GRID_WIDTH):
		var column: Array[Variant] = []
		for y in range(GRID_HEIGHT):
			column.append(null)
		grid.append(column)
		
func draw_grid_lines() -> void:
	for x in range(GRID_WIDTH + 1):
		var line: Line2D = Line2D.new()
		line.add_point(Vector2(x * BLOCK_SIZE, 0))
		line.add_point(Vector2(x * BLOCK_SIZE, GRID_HEIGHT * BLOCK_SIZE))
		line.width = 1
		line.default_color = Color.WHITE
		grid_lines.add_child(line)
		
	for y in range(GRID_HEIGHT + 1):
		var line: Line2D = Line2D.new()
		line.add_point(Vector2(0, y * BLOCK_SIZE))
		line.add_point(Vector2(GRID_WIDTH * BLOCK_SIZE, y * BLOCK_SIZE))
		line.width = 1
		line.default_color = Color.WHITE
		grid_lines.add_child(line)
		
		
		
