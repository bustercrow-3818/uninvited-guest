extends Sprite2D
class_name Grave

@export var detection: Area2D

func _ready() -> void:
	initialize()

func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	detection.body_entered.connect(lay_to_rest)

func lay_to_rest(body: Node) -> void:
	SignalBus.lay_to_rest.emit(body)
