extends StaticBody2D
class_name Switch

@export_category("Attributes")
@export var barrier_on: bool = true

@export_category("Important Nodes")
@export var area: Area2D
@export var controlled_barrier: Array[StaticBody2D]
@export var on: Sprite2D
@export var off: Sprite2D

func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	area.body_entered.connect(toggle)

func toggle(body: Node) -> void:
	if body is not Entity:
		return
		
	if body.get_move_instruction() is PossessedMovement:
		for i in controlled_barrier:
			SignalBus.turn_off_blocker.emit(i)
		on.hide()
		off.show()
	elif body is Player:
		for i in controlled_barrier:
			SignalBus.turn_on_blocker.emit(i)
		on.show()
		off.hide()
