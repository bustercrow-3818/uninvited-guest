extends Node2D

@export var player: PackedScene
@export var stages: Dictionary[int, PackedScene]

var player_reference: Player
var current_stage: TileMapLayer
var current_stage_number: int = 0

func _ready() -> void:
	initialize()

func initialize() -> void:
	connect_signals()
	spawn_player()
	load_stage(0)
	
func connect_signals() -> void:
	SignalBus.lay_to_rest.connect(stage_transition)

func spawn_player() -> void:
	var new_player: Player
	
	new_player = player.instantiate()
	add_child(new_player)
	player_reference = new_player
	player_reference.initialize()

func load_stage(next_stage: int) -> void:
	var new_stage: TileMapLayer = stages[next_stage].instantiate()
	
	if current_stage != null:
		current_stage.queue_free()
	call_deferred("add_child", new_stage)
	current_stage = new_stage
	current_stage.initialize()
	for i in current_stage.get_children():
		if i.has_method("initialize"):
			i.initialize()
			
	current_stage_number += 1

func stage_transition(body: Node) -> void:
	if current_stage_number == stages.size():
		SignalBus.final_stage_end.emit()
	elif body == player_reference:
		load_stage(current_stage_number)
