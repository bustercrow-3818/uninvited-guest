extends MovementInstructions
class_name NPCMovement

@export var walk_timer: Timer
@export var pause_timer: Timer
@export var walk_interval: Vector2i
@export var active_time_range: Vector2
@export var debug: Label

var walk: bool = false

func initialize() -> void:
	await ready
	current_state = initial_state
	restart_timer()
	connect_signals()

func connect_signals() -> void:
	walk_timer.timeout.connect(start_moving)
	pause_timer.timeout.connect(start_idle)

func process_state() -> void:
	fall()

	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

func reverse_direction() -> void:
	direction.x *= -1

func restart_timer() -> void:
	if active == true and walk_timer.is_stopped():
		walk_timer.start(randi_range(walk_interval.x, walk_interval.y))
	else:
		print("didn't restart timer")

#region state functions

func start_idle() -> void:
	restart_timer()
	change_state(states.IDLE, "idle")

func idle() -> void:
	velocity.x = move_toward(velocity.x, 0, decel)

func start_moving() -> void:
	if active == true:
		var dir_options: Array = [-1, 1]
		var pause = randf_range(active_time_range.x, active_time_range.y)

		pause_timer.start(pause)
		direction.x = dir_options.pick_random()
		change_state(states.MOVING, "walk")
		
func move(_delta) -> void:
	velocity.x = direction.x * move_speed

#endregion
