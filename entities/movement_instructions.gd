@abstract
extends Node
class_name MovementInstructions

@export_category("Physics")
@export var move_speed: float
@export var decel: float
@export var gravity: float
@export var terminal_velocity: float

var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

enum states {
	IDLE,
	DASHING,
	MOVING,
	VOID,
	STOPPING
}

var current_state := states.IDLE



func initializ() -> void:
	
	pass
	
	
func connect_signals() -> void:
	
	pass

func _physics_process(_delta: float) -> void:
	fall()
	process_state()
	
	match current_state:
		states.DASHING:
			dash(_delta)
		states.MOVING:
			move()
		states.STOPPING:
			slow()
		states.IDLE:
			idle()

func get_velocity() -> Vector2:
	return velocity

func get_state() -> states:
	return current_state

func get_state_name() -> String:
	return states.find_key(current_state)

func slow() -> void:
	if velocity.x != 0:
		velocity.x = move_toward(velocity.x, 0, decel)
	if velocity.x == 0:
		current_state = states.IDLE

func fall() -> void:
	velocity.y = move_toward(velocity.y, terminal_velocity, gravity)

func idle() -> void:
	direction = Vector2.ZERO

func dash(_delta: float) -> void:
	pass

@abstract func move() -> void

@abstract func process_state() -> void
