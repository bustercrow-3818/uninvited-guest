extends Entity
class_name NPC

@export var walk_timer: Timer
@export var walk_timer_interval: Vector2

func _ready() -> void:
	initialize()

func _physics_process(_delta: float) -> void:
	velocity = move_instructions.get_velocity()
	move_and_slide()

func random_walk() -> void:
	direction.x = randi_range(-1, 1)
	#velocity.x = direction.x * move_speed
	await get_tree().create_timer(randf_range(1,2)).timeout
	velocity.x = 0
	restart_timer()

func connect_signals() -> void:
	walk_timer.timeout.connect(random_walk)

func initialize() -> void:
	connect_signals()
	restart_timer()

func restart_timer() -> void:
	walk_timer.start(randf_range(walk_timer_interval.x, walk_timer_interval.y))
