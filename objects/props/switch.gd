extends StaticBody2D
class_name Switch

@export_category("Attributes")
@export var barrier_on: bool = true
@export var npc_mode: bool = true
@export var sister_switch: Switch


@export_category("Important Nodes")
@export var controlled_barrier: Array[StaticBody2D]
@export var area: Area2D
@export var on: Sprite2D
@export var off: Sprite2D
@export var sound: AudioStreamPlayer2D



func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	area.body_entered.connect(toggle)
	SignalBus.switch_flipped.connect(mode_switch)

func toggle(body: Node) -> void:
	if body is not Entity:
		return
	
	var barrier_check: bool = barrier_on
	
	function_check(body)
	
	if barrier_check != barrier_on:
		sound.play()
	
	SignalBus.switch_flipped.emit(self)

func function_check(body: Node2D) -> void:
	if npc_mode == true:
		if body.get_move_instruction() is PossessedMovement:
			npc_trigger()
		elif body is Player:
			ghost_trigger()
	
	else:
		if body is Player:
			npc_trigger()
		elif body.get_move_instruction() is PossessedMovement:
			ghost_trigger()

func ghost_trigger() -> void:
	for i in controlled_barrier:
		SignalBus.turn_on_blocker.emit(i)
	barrier_on = true
	on.show()
	off.hide()
	
func npc_trigger() -> void:
	for i in controlled_barrier:
		SignalBus.turn_off_blocker.emit(i)
	barrier_on = false
	on.hide()
	off.show()

func mode_switch(id: Switch) -> void:
	if id == sister_switch:
		npc_mode = !npc_mode
	else:
		pass
