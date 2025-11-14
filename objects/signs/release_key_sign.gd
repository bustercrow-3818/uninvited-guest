extends Sprite2D

@export var possess: Node2D

func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	SignalBus.possessed.connect(reveal)
	SignalBus.release.connect(done)

func reveal(_target, _mode) -> void:
	show()
	possess.hide()

func done(_target, _mode) -> void:
	hide()
