extends StaticBody2D

@export_category("Attributes")
@export var barrier_on: bool = true

@export_category("Important Nodes")
@export var area: Area2D
@export var controlled_barrier: StaticBody2D
@export var on: Sprite2D
@export var off: Sprite2D

func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	area.body_entered.connect(toggle)

func toggle(body: Node) -> void:
	if body is not Entity:
		return
		
	if body.get_move_instruction() is PossessedMovement and body is NPC:
		SignalBus.turn_off_blocker.emit(controlled_barrier)
		on.hide()
		off.show()
	elif body is Player:
		SignalBus.turn_on_blocker.emit(controlled_barrier)
		on.show()
		off.hide()
