extends MovementInstructions
class_name NPCMovement

@export var timer: Timer
@export var walk_interval: Vector2

func _ready() -> void:
	initialize()

func move() -> void:
	
	pass

func process_state() -> void:
	
	pass
	
func random_walk() -> void:
	direction.x = randi_range(-1, 1)
	#velocity.x = direction.x * move_speed
	await get_tree().create_timer(randf_range(1,2)).timeout
	velocity.x = 0
	restart_timer()
	
func restart_timer() -> void:
	timer.start(randf_range(walk_interval.x, walk_interval.y))
