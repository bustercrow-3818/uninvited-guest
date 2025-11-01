extends MovementInstructions
class_name PossessedMovement

@export var jump_speed: float

func _ready() -> void:
	initialize()

func move() -> void:
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	velocity.x = direction.x * move_speed
	if parent_on_floor == true:
		sprite.play("walk")
	else:
		pass
	
func process_state() -> void:
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
	elif velocity.x != 0:
		current_state = states.STOPPING
	elif on_floor_check() == true and velocity.x == 0:
		current_state = states.IDLE
	
func initialize() -> void:
	current_action_charges = max_action_charges
	
func connect_signals() -> void:
	
	pass
	
func action(_delta) -> void:
	if active == true and current_action_charges > 0:
		sprite.play("jump")
		velocity.y -= jump_speed
		current_action_charges -= 1
		current_state = states.FALLING
