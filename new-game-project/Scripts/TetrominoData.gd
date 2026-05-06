extends RefCounted
class_name TetrominoData

const SHAPES = [
	# I
		[[Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(3,1)],
		[Vector2i(2,0), Vector2i(2,1), Vector2i(2,2), Vector2i(2,3)],
		[Vector2i(0,2), Vector2i(1,2), Vector2i(2,2), Vector2i(3,2)],
		[Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(1,3)]],

	# T
		[[Vector2i(1,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)],
		[Vector2i(1,0), Vector2i(1,1), Vector2i(2,1), Vector2i(1,2)],
		[Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(1,2)],
		[Vector2i(1,0), Vector2i(0,1), Vector2i(1,1), Vector2i(1,2)]],

	# O
		[[Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)],
		[Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)],
		[Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)],
		[Vector2i(0,0), Vector2i(1,0), Vector2i(0,1), Vector2i(1,1)]],

	# Z
		[[Vector2i(0,0), Vector2i(1,0), Vector2i(1,1), Vector2i(2,1)],
		[Vector2i(2,0), Vector2i(1,1), Vector2i(2,1), Vector2i(1,2)],
		[Vector2i(0,1), Vector2i(1,1), Vector2i(1,2), Vector2i(2,2)],
		[Vector2i(1,0), Vector2i(0,1), Vector2i(1,1), Vector2i(0,2)]],

	# S
		[[Vector2i(1,0), Vector2i(2,0), Vector2i(0,1), Vector2i(1,1)],
		[Vector2i(1,0), Vector2i(1,1), Vector2i(2,1), Vector2i(2,2)],
		[Vector2i(1,1), Vector2i(2,1), Vector2i(0,2), Vector2i(1,2)],
		[Vector2i(0,0), Vector2i(0,1), Vector2i(1,1), Vector2i(1,2)]],

	# L
		[[Vector2i(2,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)],
		[Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(2,2)],
		[Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(0,2)],
		[Vector2i(0,0), Vector2i(1,0), Vector2i(1,1), Vector2i(1,2)]],

	# J
		[[Vector2i(0,0), Vector2i(0,1), Vector2i(1,1), Vector2i(2,1)],
		[Vector2i(1,0), Vector2i(2,0), Vector2i(1,1), Vector2i(1,2)],
		[Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(2,2)],
		[Vector2i(1,0), Vector2i(1,1), Vector2i(0,2), Vector2i(1,2)]]
]

static func get_shapes() -> Array:
	return SHAPES.duplicate(true)
