extends Entity
class_name NPC

@onready var debug: Label = $Label

@export var sprite: AnimatedSprite2D
@export var animator: AnimationPlayer

@export var npc_movement: MovementInstructions
@export var possessed_movement: MovementInstructions

func _physics_process(_delta: float) -> void:
	debug.text = move_instructions.get_state_name()
	velocity = move_instructions.get_velocity()
	move_and_slide()

func connect_signals() -> void:
	SignalBus.possessed.connect(possessed)
	SignalBus.release.connect(released)

func initialize() -> void:
	for i in get_children():
		if i is MovementInstructions:
			i.initialize()
	move_instructions.active = true
	connect_signals()

func possessed(body: Node, _new_mode: String) -> void:
	if body == self:
		move_instructions.active = false
		animator.play("possession")
		move_instructions = possessed_movement
		move_instructions.active = true
	
func released(body: Node, _new_mode: String) -> void:
	if body == self:
		move_instructions.active = false
		move_instructions.released()
		animator.play("possession")
		move_instructions = npc_movement
		move_instructions.active = true
