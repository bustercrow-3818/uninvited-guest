extends Entity
class_name NPC

@onready var debug: Label = $Label

@export var sprite: AnimatedSprite2D
@export var animator: AnimationPlayer

var modes: Dictionary


func _physics_process(_delta: float) -> void:
	debug.text = move_instructions.get_state_name()
	velocity = move_instructions.get_velocity()
	move_and_slide()
	if is_on_wall() == true and move_instructions is NPCMovement:
		move_instructions.reverse_direction()

func connect_signals() -> void:
	SignalBus.possessed.connect(switch_mode)
	SignalBus.release.connect(switch_mode)

func initialize() -> void:
	for i in get_children():
		if i is MovementInstructions:
			modes[i.name] = i
	move_instructions.active = true
	move_instructions.initialize()
	connect_signals()

func switch_mode(body: Node, new_mode: String) -> void:
	if body != self:
		return
		
	if move_instructions == modes[new_mode]:
		pass
	else:
		move_instructions.active = false
		animator.play("possession")
		move_instructions = modes[new_mode]
		move_instructions.active = true
		if move_instructions.has_method("restart_timer"):
			move_instructions.restart_timer()
