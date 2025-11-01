extends StaticBody2D

@export_category("Attributes")
@export var barrier_on: bool = true

@export_category("Important Nodes")
@export var area: Area2D
@export var controlled_barrier: StaticBody2D
@export var on: Sprite2D
@export var off: Sprite2D

func _ready() -> void:
	initialize()

func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	area.body_entered.connect(turn_off)

func turn_off(body: Node) -> void:
	var check: NPC
	if body is NPC:
		check = body
	else:
		return
	
	if check.get_move_instruction() is PossessedMovement:
		SignalBus.turn_off_blocker.emit(controlled_barrier)
		on.hide()
		off.show()
