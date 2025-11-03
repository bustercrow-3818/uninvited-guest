extends Sprite2D

func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	SignalBus.possessed.connect(reveal)

func reveal(_target, _mode) -> void:
	show()
