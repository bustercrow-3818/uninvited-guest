extends Entity
class_name NPC

func _ready() -> void:
	initialize()

func _physics_process(_delta: float) -> void:
	velocity = move_instructions.get_velocity()
	move_and_slide()

func connect_signals() -> void:
	
	pass

func initialize() -> void:
	connect_signals()
