extends StaticBody2D
class_name Blocker

@export var sprite: AnimatedSprite2D
@export var wall: Array[Sprite2D]

@export_category("Default State")
@export var active: bool = false ## Barrier default state when the stage begins.
@export var inverted: bool = false ## If false, NPCs turn off connected barriers and ghost turns them on. If true, NPCs turn on connected barriers and ghost turns them off.

@export_category("Wall Sprites")
@export var blue_wall: Texture2D
@export var red_wall: Texture2D

func activate(body: Node2D) -> void:
	if body == self:
		active = true
		collision_layer = 4
		collision_mask = 4
		sprite.play("active")
		for i in wall:
			i.texture = blue_wall
	
func deactivate(body: Node2D) -> void:
	if body == self:
		active = false
		collision_layer = 1
		collision_mask = 1
		sprite.play("inactive")
		for i in wall:
			i.texture = red_wall

func toggle(body: Node2D) -> void:
	if body != self:
		return
	
	if active == true:
		deactivate(self)
	else:
		activate(self)

func initialize() -> void:
	if active == true:
		activate(self)
	else:
		call_deferred("deactivate", self)
	connect_signals()
	
func connect_signals() -> void:
	if inverted == false:
		SignalBus.turn_off_blocker.connect(deactivate)
		SignalBus.turn_on_blocker.connect(activate)
	else:
		SignalBus.turn_off_blocker.connect(activate)
		SignalBus.turn_on_blocker.connect(deactivate)
