extends MovementInstructions
class_name NPCMovement

@export var timer: Timer
@export var walk_interval: Vector2

var moving: bool = false

func move(_delta) -> void:
	if active == true:
		direction = get_direction()
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
	fall()

	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
		
	if moving == false:
		slow()

func reverse_direction() -> void:
	velocity.x *= -1
	pass

func restart_timer() -> void:
	timer.start(randf_range(walk_interval.x, walk_interval.y))

func initialize() -> void:
	current_state = states.VOID
	connect_signals()

func connect_signals() -> void:
	timer.timeout.connect(move.bind(0))
	pass

func change_state(state: states) -> void:
	current_state = state
