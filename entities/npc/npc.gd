extends Entity
class_name NPC

@onready var debug: Label = $Label

var modes: Dictionary

func _ready() -> void:
	initialize()

func _physics_process(_delta: float) -> void:
	debug.text = move_instructions.get_state_name()
	velocity = move_instructions.get_velocity()
	move_and_slide()

func connect_signals() -> void:
	SignalBus.possessed.connect(switch_mode)
	SignalBus.release.connect(switch_mode)
	pass

func initialize() -> void:
	for i in get_children():
		if i is MovementInstructions:
			modes[i.name] = i
	connect_signals()

func switch_mode(body: Node, new_mode: String) -> void:
	if body != self:
		return
	if move_instructions == modes[new_mode]:
		pass
	else:
		move_instructions = modes[new_mode]
