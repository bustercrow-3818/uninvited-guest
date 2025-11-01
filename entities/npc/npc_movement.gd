extends MovementInstructions
class_name NPCMovement

@export var timer: Timer
@export var walk_interval: Vector2

var moving: bool = false

func _ready() -> void:
	initialize()

func move() -> void:
	if active == false:
		return
	
	moving = true
	direction.x = randi_range(-1, 1)
	velocity.x = direction.x * move_speed
	if velocity.x != 0:
		sprite.play("walk")
	await get_tree().create_timer(randf_range(3, 4)).timeout
	moving = false
	sprite.play("idle")
	restart_timer()

func process_state() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
		
	if moving == false:
		slow()
	fall()

	
func restart_timer() -> void:
	
	timer.start(randf_range(walk_interval.x, walk_interval.y))

func initialize() -> void:
	current_state = states.VOID
	connect_signals()
	restart_timer()

func connect_signals() -> void:
	timer.timeout.connect(move)

func change_state(state: states) -> void:
	current_state = state
