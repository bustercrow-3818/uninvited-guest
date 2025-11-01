@abstract
extends CharacterBody2D
class_name Entity

@export var move_instructions: MovementInstructions

var direction: Vector2

func get_move_instruction() -> MovementInstructions:
	return move_instructions

@abstract func connect_signals() -> void
	
@abstract func initialize() -> void
