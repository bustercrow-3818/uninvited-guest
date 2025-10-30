extends MovementInstructions
class_name PlayerMovement

@export var dash_speed: float
@export var dash_time: float



func move() -> void:
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	current_state = states.MOVING
	velocity.x = direction.x * move_speed
	if direction.y != 0:
		velocity.y = direction.y * move_speed
	else:
		fall()

func dash(_delta: float) -> void:
	velocity = direction * dash_speed
	await get_tree().create_timer(dash_time).timeout
	
	current_state = states.IDLE
	velocity = direction * move_speed

func process_state() -> void:
	if Input.is_action_just_pressed("dash"):
		current_state = states.DASHING
	elif (Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("right")) and current_state != states.DASHING:
		current_state = states.MOVING
	elif current_state != states.DASHING:
		current_state = states.IDLE
