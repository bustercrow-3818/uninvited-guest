extends StaticBody2D

@export var sprite: AnimatedSprite2D
@export var wall: Array[Sprite2D]
@export var active: bool = false

@export_category("Wall Sprites")
@export var blue_wall: Texture2D
@export var red_wall: Texture2D

func activate(body: Node2D) -> void:
	if body == self:
		collision_layer = 4
		collision_mask = 4
		sprite.play("active")
		for i in wall:
			i.texture = blue_wall
	
func deactivate(body: Node2D) -> void:
	if body == self:
		collision_layer = 1
		collision_mask = 1
		sprite.play("inactive")
		for i in wall:
			i.texture = red_wall

func initialize() -> void:
	if active == true:
		activate(self)
	else:
		call_deferred("deactivate", self)
	connect_signals()
	
func connect_signals() -> void:
	SignalBus.turn_off_blocker.connect(deactivate)
	SignalBus.turn_on_blocker.connect(activate)
