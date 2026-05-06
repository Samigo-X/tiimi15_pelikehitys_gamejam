extends Node2D

# ===== TETROMINOT =====
var i_tetromino = [
	[Vector2i(0,1),Vector2i(1,1),Vector2i(2,1),Vector2i(3,1)],
	[Vector2i(2,0),Vector2i(2,1),Vector2i(2,2),Vector2i(2,3)],
	[Vector2i(0,2),Vector2i(1,2),Vector2i(2,2),Vector2i(3,2)],
	[Vector2i(1,0),Vector2i(1,1),Vector2i(1,2),Vector2i(1,3)]
]

var t_tetromino = [
	[Vector2i(1,0),Vector2i(0,1),Vector2i(1,1),Vector2i(2,1)],
	[Vector2i(1,0),Vector2i(1,1),Vector2i(2,1),Vector2i(1,2)],
	[Vector2i(0,1),Vector2i(1,1),Vector2i(2,1),Vector2i(1,2)],
	[Vector2i(1,0),Vector2i(0,1),Vector2i(1,1),Vector2i(1,2)]
]

var o_tetromino = [
	[Vector2i(0,0),Vector2i(1,0),Vector2i(0,1),Vector2i(1,1)],
	[Vector2i(0,0),Vector2i(1,0),Vector2i(0,1),Vector2i(1,1)],
	[Vector2i(0,0),Vector2i(1,0),Vector2i(0,1),Vector2i(1,1)],
	[Vector2i(0,0),Vector2i(1,0),Vector2i(0,1),Vector2i(1,1)]
]

var z_tetromino = [
	[Vector2i(0,0),Vector2i(1,0),Vector2i(1,1),Vector2i(2,1)],
	[Vector2i(2,0),Vector2i(1,1),Vector2i(2,1),Vector2i(1,2)],
	[Vector2i(0,1),Vector2i(1,1),Vector2i(1,2),Vector2i(2,2)],
	[Vector2i(1,0),Vector2i(0,1),Vector2i(1,1),Vector2i(0,2)]
]

var s_tetromino = [
	[Vector2i(1,0),Vector2i(2,0),Vector2i(0,1),Vector2i(1,1)],
	[Vector2i(1,0),Vector2i(1,1),Vector2i(2,1),Vector2i(2,2)],
	[Vector2i(1,1),Vector2i(2,1),Vector2i(0,2),Vector2i(1,2)],
	[Vector2i(0,0),Vector2i(0,1),Vector2i(1,1),Vector2i(1,2)]
]

var l_tetromino = [
	[Vector2i(2,0),Vector2i(0,1),Vector2i(1,1),Vector2i(2,1)],
	[Vector2i(1,0),Vector2i(1,1),Vector2i(1,2),Vector2i(2,2)],
	[Vector2i(0,1),Vector2i(1,1),Vector2i(2,1),Vector2i(0,2)],
	[Vector2i(0,0),Vector2i(1,0),Vector2i(1,1),Vector2i(1,2)]
]

var j_tetromino = [
	[Vector2i(0,0),Vector2i(0,1),Vector2i(1,1),Vector2i(2,1)],
	[Vector2i(1,0),Vector2i(2,0),Vector2i(1,1),Vector2i(1,2)],
	[Vector2i(0,1),Vector2i(1,1),Vector2i(2,1),Vector2i(2,2)],
	[Vector2i(1,0),Vector2i(1,1),Vector2i(0,2),Vector2i(1,2)]
]

var tetrominoes = [i_tetromino,t_tetromino,o_tetromino,z_tetromino,s_tetromino,l_tetromino,j_tetromino]
var all_tetrominoes = tetrominoes.duplicate()

# ===== CONSTANTS =====
const COLS = 12
const ROWS = 22
const START_POSITION = Vector2i(5,1)

# ===== GAME STATE =====
var current_position: Vector2i
var current_tetromino_type: Array
var rotation_index := 0
var active_tetromino: Array

# ===== FALL SYSTEM =====
var fall_timer := 0.0
var fall_interval := 1.0
var fast_fall_multiplier := 10.0

# ===== TILE =====
var tile_id := 0
var piece_atlas: Vector2i

@onready var board_layer = $Board
@onready var active_layer = $Active

# ===== START =====
func _ready():
	start_new_game()

func start_new_game():
	current_tetromino_type = choose_tetromino()
	piece_atlas = Vector2i(all_tetrominoes.find(current_tetromino_type),0)
	initialize_tetromino()

func choose_tetromino():
	if tetrominoes.is_empty():
		tetrominoes = all_tetrominoes.duplicate()
	tetrominoes.shuffle()
	return tetrominoes.pop_front()

func initialize_tetromino():
	# GAME OVER -tarkistus
	for block in current_tetromino_type[0]:
		if board_layer.get_cell_source_id(START_POSITION + block) != -1:
			print("GAME OVER")
			get_tree().paused = true
			return

	current_position = START_POSITION
	rotation_index = 0
	active_tetromino = current_tetromino_type[rotation_index]
	draw_tetromino()

# ===== DRAW =====
func draw_tetromino():
	for block in active_tetromino:
		active_layer.set_cell(current_position + block, 0, piece_atlas)

func clear_tetromino():
	for block in active_tetromino:
		active_layer.set_cell(current_position + block, -1)

# ===== LUKITUS =====
func lock_tetromino():
	for block in active_tetromino:
		board_layer.set_cell(current_position + block, 0, piece_atlas)
	clear_tetromino()

# ===== INPUT & PHYSICS =====
func _physics_process(delta):
	var move = Vector2i.ZERO
	
	if Input.is_action_just_pressed("ui_left"):
		move = Vector2i.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		move = Vector2i.RIGHT
		
	if move != Vector2i.ZERO:
		move_tetromino(move)

	if Input.is_action_just_pressed("ui_up"):
		rotate_tetromino()

	var speed = fall_interval
	if Input.is_action_pressed("ui_down"):
		speed /= fast_fall_multiplier
		
	fall_timer += delta
	if fall_timer >= speed:
		move_tetromino(Vector2i.DOWN)
		fall_timer = 0

# ===== MOVEMENT =====
func move_tetromino(dir: Vector2i):
	if dir == Vector2i.DOWN:
		if is_valid_move(dir):
			clear_tetromino()
			current_position += dir
			draw_tetromino()
		else:
			lock_tetromino()
			start_new_game()
		return

	if is_valid_move(dir):
		clear_tetromino()
		current_position += dir
		draw_tetromino()

func rotate_tetromino():
	var next_rotation = (rotation_index + 1) % 4
	var rotated = current_tetromino_type[next_rotation]
	
	for block in rotated:
		if not is_valid_position(current_position + block):
			return
	
	clear_tetromino()
	rotation_index = next_rotation
	active_tetromino = rotated
	draw_tetromino()

# ===== CHECKS =====
func is_valid_move(dir: Vector2i) -> bool:
	for block in active_tetromino:
		if not is_valid_position(current_position + block + dir):
			return false
	return true

func is_valid_position(pos: Vector2i) -> bool:
	if pos.x < 0 or pos.x >= COLS or pos.y < 0 or pos.y >= ROWS:
		return false
		
	var cell_id = board_layer.get_cell_source_id(pos)
	return cell_id == -1
