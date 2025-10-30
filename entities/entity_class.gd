@abstract
extends CharacterBody2D
class_name Entity

@export var move_instructions: MovementInstructions

var direction: Vector2

@abstract func connect_signals() -> void
	
@abstract func initialize() -> void
