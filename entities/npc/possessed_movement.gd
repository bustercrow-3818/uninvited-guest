extends MovementInstructions
class_name PossessedMovement

@export var jump_speed: float
@export var jump_sound: AudioStreamPlayer2D

func move(_delta: float) -> void:
	direction = get_direction()
	velocity.x = move_toward(velocity.x, move_speed * direction.x, accel)
	
	if on_floor_check() == false:
		pass
	else:
		sprite.play("walk")
	
func get_direction() -> Vector2:
	var _direction = Vector2.ZERO
	
	if (Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		_direction = Input.get_vector("left", "right", "up", "down").normalized()
	
	return _direction
	
func process_state() -> void:
	fall()
	
	if on_floor_check() == true:
		current_action_charges = max_action_charges
		velocity.y = 0
	
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
	
	if Input.is_action_just_pressed("action"):
		current_state = states.ACTION
	elif (Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		current_state = states.MOVING
	elif on_floor_check() == true and direction.x == 0:
		current_state = states.IDLE
	
func initialize() -> void:
	current_action_charges = max_action_charges
	
func connect_signals() -> void:
	
	pass
	
func action(_delta) -> void:
	if active == true and current_action_charges > 0:
		jump_sound.play()
		sprite.play("jump")
		velocity.y -= jump_speed
		current_action_charges -= 1
		current_state = states.FALLING
