extends MovementInstructions
class_name PlayerMovement


@export_category("Dash Stats")
@export var speed: float
@export var time: float
@export var cooldown_time: float

var cooling: bool = false

func initialize() -> void:
	velocity = Vector2.ZERO
	active = true

func move(_delta: float) -> void:
	direction = get_direction()
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * move_speed, accel)

func action(_delta: float) -> void:
	
	if cooling == false:
		direction = get_direction()
		velocity = direction * speed
		await get_tree().create_timer(time).timeout
		cooling = true
		cooldown()
	
	current_state = states.IDLE
	velocity = direction * move_speed

func cooldown() -> void:
	await get_tree().create_timer(cooldown_time).timeout
	cooling = false

func process_state() -> void:
	if Input.is_action_just_pressed("action"):
		current_state = states.ACTION
	elif (Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("right")) and current_state != states.ACTION:
		current_state = states.MOVING
	elif current_state != states.ACTION:
		current_state = states.IDLE
	

func idle() -> void:
	velocity = velocity.move_toward(Vector2.ZERO, decel)
	if velocity == Vector2.ZERO:
		sprite.play("idle")

func slow() -> void:
	pass

func get_direction() -> Vector2:
	var _direction = Vector2.ZERO
	
	if (Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		_direction = Input.get_vector("left", "right", "up", "down").normalized()
	
	return _direction
