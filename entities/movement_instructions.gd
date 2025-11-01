@abstract
extends Node
class_name MovementInstructions

@export_category("Physics")
@export var move_speed: float
@export var decel: float
@export var gravity: float
@export var terminal_velocity: float

@export_category("Other Stats")
@export var max_action_charges: int = 1
@export var sprite: AnimatedSprite2D

var parent_on_floor: bool = true
var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var active: bool = false
var current_action_charges: int = 1

enum states {
	IDLE,
	ACTION,
	MOVING,
	VOID,
	STOPPING,
	FALLING
}

var current_state := states.IDLE



func initialize() -> void:
	
	pass
	
	
func connect_signals() -> void:
	
	pass

func _physics_process(_delta: float) -> void:
	if active == true:
		fall()
		process_state()
		
		match current_state:
			states.ACTION:
				action(_delta)
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
		velocity.x -= decel * direction.x

func fall() -> void:
	velocity.y += gravity
	if velocity.y > terminal_velocity:
		velocity.y = terminal_velocity

func idle() -> void:
	sprite.play("idle")

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

@abstract func move() -> void

@abstract func process_state() -> void
