extends MovementInstructions
class_name PossessedMovement

@export var jump_speed: float
@export var jump_sound: AudioStreamPlayer2D

func get_direction() -> Vector2:
	var dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	return dir

func process_state() -> void:
	
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

func initialize() -> void:
	current_action_charges = max_action_charges
	current_state = initial_state

func connect_signals() -> void:
	
	pass

#region state functions
func action(_delta) -> void:
	jump_sound.play()
	velocity.y -= jump_speed
	current_action_charges -= 1
	
	change_state(states.FALLING)

func idle() -> void:
	velocity.x = move_toward(velocity.x, 0, decel)
	velocity.y = 0
	
	if Input.is_action_just_pressed("action"):
		change_state(states.ACTION, "jump")
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		change_state(states.MOVING, "walk")

func move(_delta: float) -> void:
	direction.x = get_direction().x
	velocity.x = move_toward(velocity.x, move_speed * direction.x, accel)
	
	if Input.is_action_just_pressed("action"):
		change_state(states.ACTION, "jump")
	elif on_floor_check() == false:
		change_state(states.FALLING, "jump")
	elif on_floor_check() == true and direction.x == 0:
		change_state(states.IDLE, "idle")

func falling() -> void:
	fall()
	direction.x = get_direction().x
	velocity.x = move_toward(velocity.x, move_speed * direction.x, accel)
	
	if Input.is_action_just_pressed("action") and current_action_charges > 0:
		change_state(states.ACTION, "jump")
	elif on_floor_check() == true:
		current_action_charges = max_action_charges
		change_state(states.IDLE, "idle")


#endregion
