extends MovementInstructions
class_name PossessedMovement

func move() -> void:
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	velocity.x = direction.x * move_speed
	
func process_state() -> void:
	if (Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		current_state = states.MOVING
	else:
		current_state = states.STOPPING
	
func initialize() -> void:
	
	pass
	
func connect_signals() -> void:
	
	pass
	
