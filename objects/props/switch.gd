extends StaticBody2D
class_name Switch

@export_category("Attributes")
@export var barrier_on: bool = true ## Used to decide the initially visible sprite and for checking if a sound should be played.
@export var npc_mode: bool = true ## If NPC Mode is true, uses normal behavior (NPC turns off, ghost turns on). If NPC Mode is false, inverts this behavior. This mode can be swapped freely in-game by assigning another lever to the Sister Switch which will invert this value on activation.
@export var sister_switch: Switch


@export_category("Important Nodes")
@export var controlled_barrier: Array[Blocker]
@export var area: Area2D
@export var on: Sprite2D ## Connected barrier is activated, ready for NPC action
@export var off: Sprite2D ## Connected barrier is deactivated, ready for ghost action
@export var sound: AudioStreamPlayer2D

@export_category("Debug")
@export var debug_label: Label

func initialize() -> void:
	if not barrier_on:
		on.hide()
		off.show()
	connect_signals()
	
func connect_signals() -> void:
	area.body_entered.connect(function_check)
	#for i in controlled_barrier:
		#i.toggled.connect(blocker_connection)

## Used to decide how to behave depending on NPC Mode. If NPC Mode is true, uses normal behavior (NPC turns off, ghost turns on). If NPC Mode is false, inverts this behavior. This mode can be swapped freely in-game by assigning another lever to the Sister Switch
func function_check(body: Node2D) -> void:
	if body is not Entity:
		return
	
	if body.move_instructions is PossessedMovement:
		npc_entered()
	elif body is Player:
		ghost_entered()

func npc_entered() -> void:
	if npc_mode == barrier_on:
		npc_trigger()

func ghost_entered() -> void:
	if npc_mode != barrier_on:
		ghost_trigger()

func toggle_switch() -> void:
	on.visible = !on.visible
	off.visible = !off.visible
	barrier_on = !barrier_on

func ghost_trigger() -> void:
	for i in controlled_barrier:
		i.toggle()
		if sister_switch != null:
			i.inverted = !i.inverted
	
	toggle_switch()
	sound.play()
	
	if sister_switch != null:
		sister_switch.toggle_switch()
		sister_switch.barrier_on = !barrier_on
	
func npc_trigger() -> void:
	for i in controlled_barrier:
		i.toggle()
		if sister_switch != null:
			i.inverted = !i.inverted

	toggle_switch()
	sound.play()
	
	if sister_switch != null:
		sister_switch.toggle_switch()
		sister_switch.barrier_on = !barrier_on

func blocker_connection(state: bool) -> void:
	barrier_on = state
