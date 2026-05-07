extends Node2D

const BoardLogicScript = preload("res://Scripts/BoardLogic.gd")

var all_tetrominoes := TetrominoData.get_shapes()
var tetrominoes := all_tetrominoes.duplicate(true)
var score_manager := ScoreManager.new()
var board_logic

# ===== CONSTANTS =====
const START_POSITION = Vector2i(3, 0)
const GHOST_ATLAS = Vector2i(7, 0)

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

# ===== HOLD =====
var hold_tetromino_type: Array = []
var can_hold := true

@onready var board_layer = $Board
@onready var active_layer = $Active
@onready var ghost_layer = $Ghost
@onready var score_label: Label = $ScoreLabel
@onready var lines_label: Label = $LinesLabel
@onready var level_label: Label = $LevelLabel
@onready var hold_layer = $HoldLayer

# ===== START =====
func _ready():
	board_logic = BoardLogicScript.new(board_layer)
	update_ui()
	start_new_game()

func start_new_game():
	current_tetromino_type = choose_tetromino()
	piece_atlas = Vector2i(all_tetrominoes.find(current_tetromino_type), 0)
	initialize_tetromino()

func choose_tetromino():
	if tetrominoes.is_empty():
		tetrominoes = all_tetrominoes.duplicate(true)
	tetrominoes.shuffle()
	return tetrominoes.pop_front()

func initialize_tetromino():
	for block in current_tetromino_type[0]:
		if not board_logic.is_valid_position(START_POSITION + block):
			print("GAME OVER")
			get_tree().paused = true
			return

	current_position = START_POSITION
	rotation_index = 0
	active_tetromino = current_tetromino_type[rotation_index]
	draw_tetromino()

# ===== DRAW =====
func draw_tetromino():
	clear_ghost()
	draw_ghost()
	
	for block in active_tetromino:
		active_layer.set_cell(board_logic.board_pos(current_position + block), 0, piece_atlas)

func clear_tetromino():
	clear_ghost()
	
	for block in active_tetromino:
		active_layer.set_cell(board_logic.board_pos(current_position + block), -1)

# ===== LUKITUS =====
func lock_tetromino():
	board_logic.lock_blocks(current_position, active_tetromino, piece_atlas)
	clear_tetromino()
	can_hold = true  # <-- tänne
	
	var cleared_rows = board_logic.clear_full_rows()
	if cleared_rows > 0:
		add_score(cleared_rows)

func add_score(row_count: int):
	score_manager.add_lines(row_count)
	update_ui()
	
func update_ui():
	score_label.text = "Score: " + str(score_manager.score)
	lines_label.text = "Lines: " + str(score_manager.lines_cleared)
	level_label.text = "Level: " + str(score_manager.level)

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
	
	if Input.is_action_just_pressed("drop"):
		hard_drop()
	
	if Input.is_action_just_pressed("hold"):
		hold_piece()

func hard_drop():
	while is_valid_move(Vector2i.DOWN):
		clear_tetromino()
		current_position += Vector2i.DOWN
		draw_tetromino()
	lock_tetromino()
	start_new_game()

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
		if not board_logic.is_valid_position(current_position + block):
			return
	
	clear_tetromino()
	rotation_index = next_rotation
	active_tetromino = rotated
	draw_tetromino()

# ===== CHECKS =====
func is_valid_move(dir: Vector2i) -> bool:
	for block in active_tetromino:
		if not board_logic.is_valid_position(current_position + block + dir):
			return false
	return true

# ===== GHOST =====
func get_ghost_position() -> Vector2i:
	var ghost_pos = current_position
	
	while true:
		var next = ghost_pos + Vector2i.DOWN
		
		for block in active_tetromino:
			if not board_logic.is_valid_position(next + block):
				return ghost_pos
		ghost_pos = next
	
	return ghost_pos

func draw_ghost():
	var ghost_pos = get_ghost_position()
	
	if ghost_pos == current_position:
		return
	
	for block in active_tetromino:
		ghost_layer.set_cell(board_logic.board_pos(ghost_pos + block), 0, GHOST_ATLAS)

func clear_ghost():
	ghost_layer.clear()

func hold_piece():
	if not can_hold:
		return
	
	clear_tetromino()
	
	if hold_tetromino_type.is_empty():
		hold_tetromino_type = current_tetromino_type
		start_new_game()
	else:
		var temp = hold_tetromino_type
		hold_tetromino_type = current_tetromino_type
		current_tetromino_type = temp
		piece_atlas = Vector2i(all_tetrominoes.find(current_tetromino_type), 0)
		initialize_tetromino()
	
	can_hold = false
	draw_hold()

func draw_hold():
	hold_layer.clear()
	
	if hold_tetromino_type.is_empty():
		return
	
	var hold_atlas = Vector2i(all_tetrominoes.find(hold_tetromino_type), 0)
	
	for block in hold_tetromino_type[0]:
		hold_layer.set_cell(block, 0, hold_atlas)
