extends Button

@export var room: TileMapLayer

func _ready() -> void:
	connect_signals()

func initialize() -> void:
	room.initialize()
	
func connect_signals() -> void:
	pressed.connect(initialize)
	pass
	
