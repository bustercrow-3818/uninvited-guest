extends Blocker
class_name RotatingBlocker

@export var animation: AnimationPlayer

func initialize() -> void:
	super()
	animation.play("rotate")
