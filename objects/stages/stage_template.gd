extends TileMapLayer

@export var spawn_point: Node2D

var bounds: Vector2

func initialize() -> void:
	bounds = get_used_rect().size * tile_set.tile_size
	SignalBus.broadcast_bounds.emit(bounds)
	SignalBus.place_player.emit(spawn_point.position)

func get_bounds() -> Vector2:
	return bounds
