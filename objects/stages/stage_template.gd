extends TileMapLayer

var bounds: Vector2

func _ready() -> void:
	initialize()

func initialize() -> void:
	bounds = get_used_rect().size * tile_set.tile_size
	SignalBus.broadcast_bounds.emit(bounds)

func get_bounds() -> Vector2:
	return bounds
