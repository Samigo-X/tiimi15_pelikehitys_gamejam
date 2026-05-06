extends RefCounted
class_name ScoreManager

var score := 0
var lines_cleared := 0
var level := 1

func add_lines(row_count: int):
	lines_cleared += row_count
	level = 1 + floori(lines_cleared / 10.0)

	match row_count:
		1: score += 100 * level
		2: score += 300 * level
		3: score += 500 * level
		4: score += 800 * level
