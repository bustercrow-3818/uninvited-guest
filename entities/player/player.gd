extends Entity
class_name Player

@onready var label: Label = $status

@export var sprite: AnimatedSprite2D
@export var camera: Camera2D
@export var collision_shape: CollisionShape2D

var possessing: bool = false

func _ready() -> void:
	initialize()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("release") and possessing == true:
		release_victim()
	
	if possessing == true:
		pass
	else:
		if velocity.x > 0:
			sprite.flip_h = true
		elif velocity.x < 0:
			sprite.flip_h = false
		
		velocity = move_instructions.get_velocity()
		move_and_slide()
		possess_target()

func connect_signals() -> void:
	SignalBus.broadcast_bounds.connect(set_cam_bounds)
	SignalBus.lay_to_rest.connect(lay_to_rest)

func initialize() -> void:
	SignalBus.request_bounds.emit()
	connect_signals()

func set_cam_bounds(bounds: Vector2) -> void:
	@warning_ignore("narrowing_conversion")
	camera.limit_bottom = bounds.y
	@warning_ignore("narrowing_conversion")
	camera.limit_right = bounds.x
	camera.limit_top = 0
	camera.limit_left = 0

func possess_target() -> void:
	var state = move_instructions.get_state()
	if move_and_slide() == true and state == move_instructions.states.ACTION:
		var collision = get_last_slide_collision().get_collider()
		if collision is Entity:
			switch_pov(collision)
			collision.modulate = Color(0.154, 0.653, 0.934, 1.0)

func switch_pov(target: Node) -> void:
	var tween = create_tween()
	
	camera.reparent(target)
	tween.tween_property(camera, "position", Vector2.ZERO, 0.15)
	camera.position = Vector2.ZERO
	modulate = Color(.85, .35, .07, 0.5)
	collision_shape.disabled = true
	possessing = true
	SignalBus.possessed.emit(target, "PossessedMovement")

func release_victim() -> void:
	var victim: Node = camera.get_parent()
	var tween = create_tween()
	
	victim.modulate = Color(1, 1, 1, 1)
	possessing = false
	modulate = Color(1, 1, 1, 0.75)
	collision_shape.disabled = false
	camera.reparent(self)
	tween.tween_property(camera, "position", Vector2.ZERO, 0.15)
	SignalBus.release.emit(victim, "NPCMovement")

func lay_to_rest(body: Node) -> void:
	if body == self:
		label.text = "victory"
	pass
