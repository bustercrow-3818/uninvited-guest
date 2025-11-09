@abstract
extends Node
class_name MovementInstructions

@export_category("State Machine")
@export var initial_state: states

@export_category("Physics")
@export var move_speed: float
@export var accel: float
@export var decel: float
@export var gravity: float
@export var terminal_velocity: float

@export_category("Other Stats")
@export var max_action_charges: int = 1
@export var sprite: AnimatedSprite2D

var velocity: Vector2 = Vector2.ZERO
var active: bool = false
var current_action_charges: int = 1
var direction: Vector2

enum states {
	IDLE,
	ACTION,
	MOVING,
	VOID,
	STOPPING,
	FALLING
}

var current_state: states



func initialize() -> void:
	
	pass
	
func connect_signals() -> void:
	
	pass

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
			states.IDLE:
				idle()

func get_velocity() -> Vector2:
	return velocity

func get_state() -> states:
	return current_state

func get_state_name() -> String:
	return states.find_key(current_state)

func fall() -> void:
	velocity.y += gravity
	if velocity.y > terminal_velocity:
		velocity.y = terminal_velocity

func falling() -> void:
	pass

func idle() -> void:
	pass

func action(_delta: float) -> void:
	pass

func restore_action_charges() -> void:
	pass

func on_floor_check() -> bool:
	var parent: CharacterBody2D = get_parent()
	var check: bool
	
	if parent.is_on_floor() == true:
		check = true
	elif parent.is_on_floor() == false:
		check = false
		
	return check

func change_state(new_state: states, _animation: String = "none") -> void:
	current_state = new_state
	if _animation == "none":
		pass
	else:
		sprite.play(_animation)

@abstract func move(_delta: float) -> void

@abstract func process_state() -> void
