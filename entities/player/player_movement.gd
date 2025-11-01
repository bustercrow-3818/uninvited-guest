extends MovementInstructions
class_name PlayerMovement


@export_category("Dash Stats")
@export var speed: float
@export var time: float
@export var cooldown_time: float

var cooling: bool = false

func _ready() -> void:
	initialize()

func initialize() -> void:
	active = true

func move() -> void:
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	current_state = states.MOVING
	velocity.x = direction.x * move_speed
	if direction.y != 0:
		velocity.y = direction.y * move_speed
	else:
		fall()

func action(_delta: float) -> void:
	if cooling == false:
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
		current_state = states.STOPPING
