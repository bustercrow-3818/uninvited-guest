extends StaticBody2D
class_name Switch

@export_category("Attributes")
@export var barrier_on: bool = true ## Used to decide the initially visible sprite and for checking if a sound should be played.
@export var npc_mode: bool = true ## If NPC Mode is true, uses normal behavior (NPC turns off, ghost turns on). If NPC Mode is false, inverts this behavior. This mode can be swapped freely in-game by assigning another lever to the Sister Switch which will invert this value on activation.
@export var sister_switch: Switch


@export_category("Important Nodes")
@export var controlled_barrier: Array[StaticBody2D]
@export var area: Area2D
@export var on: Sprite2D ## Connected barrier is activated, ready for NPC action
@export var off: Sprite2D ## Connected barrier is deactivated, ready for ghost action
@export var sound: AudioStreamPlayer2D



func initialize() -> void:
	if not barrier_on:
		on.hide()
		off.show()
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

## Used to decide how to behave depending on NPC Mode. If NPC Mode is true, uses normal behavior (NPC turns off, ghost turns on). If NPC Mode is false, inverts this behavior. This mode can be swapped freely in-game by assigning another lever to the Sister Switch
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

func flip_sister() -> void:
	barrier_on = !barrier_on
	on.visible = !on.visible
	off.visible = !off.visible
	npc_mode = !npc_mode
