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
	parent = get_parent()
	restart_timer()
	connect_signals()

func connect_signals() -> void:
	walk_timer.timeout.connect(start_moving)
	pause_timer.timeout.connect(stop_moving)

func process_state() -> void:
	if parent.is_on_wall():
		reverse_direction()
	
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

func released() -> void:
	start_idle()
	change_state(states.IDLE, "idle")

func reverse_direction() -> void:
	direction.x *= -1

#region State Machine

	#region actual states

func idle() -> void:
	velocity.x = move_toward(velocity.x, 0, decel)
	
	if parent.is_on_floor() != true:
		change_state(states.FALLING, "jump")
	if walk == true:
		initialize_walk_parameters()
		change_state(states.MOVING, "walk")
	
func falling() -> void:
	fall()
	
	if parent.is_on_floor():
		start_idle()
		change_state(states.IDLE, "idle")
	
func move(_delta) -> void:
	velocity.x = direction.x * move_speed

	if parent.is_on_floor() != true:
		change_state(states.FALLING, "jump")
	elif walk == false:
		start_idle()
		change_state(states.IDLE, "idle")
	
	#endregion

	#region helper functions

func restart_timer() -> void:
	if active == true and walk_timer.is_stopped():
		walk_timer.start(randi_range(walk_interval.x, walk_interval.y))

func start_idle() -> void:
	restart_timer()

func start_moving() -> void:
	walk = true

func initialize_walk_parameters() -> void:
	if active == true:
		var dir_options: Array = [-1, 1]
		var pause = randf_range(active_time_range.x, active_time_range.y)

		pause_timer.start(pause)
		direction.x = dir_options.pick_random()
		
func stop_moving() -> void:
	walk = false
	
	#endregion

#endregion
