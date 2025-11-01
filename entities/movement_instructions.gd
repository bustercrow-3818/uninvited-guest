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
		on_floor_check()
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
		velocity.x = move_toward(velocity.x, 0, decel)
	if velocity.x == 0:
		current_state = states.IDLE

func fall() -> void:
	velocity.y = move_toward(velocity.y, terminal_velocity, gravity)

func idle() -> void:
	sprite.play("idle")

func action(_delta: float) -> void:
	pass

func restore_action_charges() -> void:
	pass

func on_floor_check() -> void:
	var parent: CharacterBody2D = get_parent()
	
	if parent.is_on_floor():
		parent_on_floor = true
	else:
		parent_on_floor = false

@abstract func move() -> void

@abstract func process_state() -> void
