extends PossessedMovement
class_name PossessedSpider

var original_rotation

func initialize() -> void:
	await ready
	parent = get_parent()
	original_rotation = parent.rotation_degrees

func process_state() -> void:
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false

func _physics_process(_delta: float) -> void:
	if active == true:
		process_state()
		
		match current_state:
			states.ACTION:
				action(_delta)
			states.MOVING:
				move(_delta)
			states.FALLING:
				falling()
			states.CLIMBING:
				climbing()
			states.CLINGING:
				clinging()
			states.IDLE:
				idle()

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
	elif parent.is_on_wall():
		if parent.get_last_slide_collision().get_normal().x > 0:
			parent.rotate(deg_to_rad(original_rotation))
		else:
			parent.rotate(deg_to_rad(original_rotation))
		change_state(states.CLINGING, "idle")
	elif on_floor_check() == true:
		current_action_charges = max_action_charges
		change_state(states.IDLE, "idle")

func climbing() -> void:
	direction = get_direction()
	velocity.y = move_toward(velocity.y, move_speed * direction.y, accel)
	
	if direction.y > 0:
		sprite.flip_h = true
	elif direction.y < 0:
		sprite.flip_h = false
	
	if direction.y == 0:
		change_state(states.CLINGING, "idle")
	elif Input.is_action_just_pressed("action"):
		velocity.x = get_direction().x * jump_speed
		parent.rotation_degrees -= original_rotation
		change_state(states.FALLING, "jump")

func clinging() -> void:
	velocity = Vector2.ZERO
	
	
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
		change_state(states.CLIMBING, "walk")
	elif Input.is_action_just_pressed("action"):
		velocity.x = get_direction().x * jump_speed
		sprite.rotation_degrees -= original_rotation
		change_state(states.FALLING, "jump")

#endregion
