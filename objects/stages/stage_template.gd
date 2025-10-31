extends TileMapLayer

var bounds: Rect2

func initialize() -> void:
	bounds = get_used_rect() * tile_set.x

func get_bounds() -> Rect2:
	return bounds
