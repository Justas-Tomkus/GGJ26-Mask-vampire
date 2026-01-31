extends Camera2D

@export var backgrounds :Array[Sprite2D]

func _ready() -> void:
	ready_limits()

func ready_limits() -> void:
	var min :Vector2 = Vector2(100000, 10000)
	# Note(Justas): universally incorrect, but fine enough in our small case
	var max :Vector2 = Vector2.ZERO
	for sp in backgrounds:
		var gpos = sp.global_position
		if min.x > gpos.x:
			min.x = gpos.x
		if min.y > gpos.y:
			min.y = gpos.y
		var s = sp.get_rect().size
		if max.x < gpos.x + s.x:
			max.x = gpos.x + s.x
		if max.y < gpos.y + s.y:
			max.y = gpos.y + s.y
	limit_left = min.x
	limit_right = max.x
	limit_top = min.y
	limit_bottom = max.y
		
