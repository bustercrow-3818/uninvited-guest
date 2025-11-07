extends Sprite2D
class_name Grave

@export var detection: Area2D
@export var sound: AudioStreamPlayer2D

func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	detection.body_entered.connect(lay_to_rest)

func lay_to_rest(body: Node) -> void:
	SignalBus.lay_to_rest.emit(body)
	sound.play()
	SignalBus.location_announce.emit(position)
