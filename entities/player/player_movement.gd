extends MovementInstructions
class_name PlayerMovement

@export var debug: Label

@export_category("Dash Stats")
@export var dash_speed: float
@export var time: float
@export var cooldown_time: float
@export var sound: AudioStreamPlayer2D
@export var cooldown_timer: Timer

var cooling: bool = false

func _process(_delta: float) -> void:
	debug.text = "Current State: %s" % get_state_name()

func initialize() -> void:
	connect_signals()
	current_state = initial_state
	velocity = Vector2.ZERO
	active = true

func connect_signals() -> void:
	cooldown_timer.timeout.connect(cooldown)

func cooldown() -> void:
	cooling = false

func process_state() -> void:
	pass
	
func slow() -> void:
	pass

func get_direction() -> Vector2:
	var _direction = Vector2.ZERO
	
	if (Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		_direction = Input.get_vector("left", "right", "up", "down").normalized()
	
	return _direction



#region state functions

func idle() -> void:
	velocity = velocity.move_toward(Vector2.ZERO, decel)
	
	#region state change logic
	if Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		change_state(states.MOVING, "idle")
	#endregion

func action(_delta: float) -> void:
	cooling = true
	velocity = direction * dash_speed
	velocity = velocity.move_toward(Vector2.ZERO, decel)
	await get_tree().create_timer(time).timeout
	
	velocity = direction * move_speed
	change_state(states.MOVING, "idle")

func move(_delta: float) -> void:
	direction = get_direction()
	velocity = velocity.move_toward(direction * move_speed, accel)
	
	if Input.is_action_just_pressed("action") and cooling == false:
		sound.play()
		cooldown_timer.start(cooldown_time)
		change_state(states.ACTION, "dash")
	elif velocity == Vector2.ZERO:
		change_state(states.IDLE, "idle")

#endregion
