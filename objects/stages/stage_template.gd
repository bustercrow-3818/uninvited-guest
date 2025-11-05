extends TileMapLayer
class_name Stage


@export var spawn_point: Node2D

var bounds: Vector2

func initialize() -> void:
	bounds = get_used_rect().size * tile_set.tile_size
	SignalBus.broadcast_bounds.emit(bounds)
	for i in get_children():
		if i.has_method("initialize"):
			i.initialize()

func get_bounds() -> Vector2:
	return bounds

func get_spawn_position() -> Vector2:
	return spawn_point.position
