extends Sprite2D

func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	SignalBus.turn_off_blocker.connect(reveal)

func reveal(_target) -> void:
	show()
