extends CharacterBody2D
class_name Player

@export var move_speed: float
@export var dash_speed: float
@export var dash_time: float
@export var gravity: float ## Keep small to maintain floatiness
@export var terminal_velocity: float

@export var sprite: AnimatedSprite2D

@onready var status: Label = $status

enum states {
	IDLE,
	DASHING,
	FLOATING
}

var current_state := states.IDLE
var direction: Vector2

func _physics_process(_delta: float) -> void:
	status.text = "State: " + str(velocity)
	
	slow()
	
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false
	
	if Input.is_action_just_pressed("dash"):
		current_state = states.DASHING
	elif (Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("right")) and current_state != states.DASHING:
		current_state = states.FLOATING
	elif current_state != states.DASHING:
		current_state = states.IDLE
	
	match current_state:
		states.DASHING:
			dash(_delta)
		states.FLOATING:
			float_on()
		states.IDLE:
			direction = Vector2.ZERO
			
	move_and_slide()

func float_on() -> void:
	if current_state != states.DASHING:
		direction = Input.get_vector("left", "right", "up", "down").normalized()
		current_state = states.FLOATING
		velocity.x = direction.x * move_speed
		if direction.y != 0:
			velocity.y = direction.y * move_speed
		else:
			fall()
	else:
		pass
		

func dash(_delta: float) -> void:
	velocity = direction * dash_speed
	await get_tree().create_timer(dash_time).timeout
	
	current_state = states.IDLE
	velocity = direction * move_speed

func slow() -> void:
	if velocity.x != 0:
		velocity.x = move_toward(velocity.x, 0, gravity)
	fall()

func fall() -> void:
	velocity.y = move_toward(velocity.y, terminal_velocity, gravity)
