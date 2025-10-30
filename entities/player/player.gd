extends Entity
class_name Player

@export var dash_speed: float
@export var dash_time: float

@export var sprite: AnimatedSprite2D

@onready var status: Label = $status

enum states {
	IDLE,
	DASHING,
	FLOATING
}

var current_state := states.IDLE



func _physics_process(_delta: float) -> void:
	status.text = "State: " + str(velocity)
	
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false
	
	velocity = move_instructions.get_velocity()
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

func connect_signals() -> void:
	pass

func initialize() -> void:
	pass
