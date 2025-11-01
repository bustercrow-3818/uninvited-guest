extends StaticBody2D

@export var blocker: CollisionShape2D
@export var sprite: AnimatedSprite2D

@export var active: bool = false

func _ready() -> void:
	initialize()

func activate(body: Node2D) -> void:
	if body == self:
		blocker.disabled = false
		sprite.play("active")
	
func deactivate(body: Node2D) -> void:
	if body == self:
		blocker.call_deferred("set_disabled", true)
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
