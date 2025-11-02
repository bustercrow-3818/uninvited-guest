extends StaticBody2D

@export var sprite: AnimatedSprite2D

@export var active: bool = false

func activate(body: Node2D) -> void:
	if body == self:
		collision_layer = 4
		collision_mask = 4
		sprite.play("active")
	
func deactivate(body: Node2D) -> void:
	if body == self:
		collision_layer = 1
		collision_mask = 1
		sprite.play("inactive")

func initialize() -> void:
	if active == true:
		activate(self)
	else:
		call_deferred("deactivate", self)
	connect_signals()
	
func connect_signals() -> void:
	SignalBus.turn_off_blocker.connect(deactivate)
	SignalBus.turn_on_blocker.connect(activate)
