extends Node2D

@export_category("Misc.")
@export var starting_stage: int

@export_category("Data")
@export var player: PackedScene
@export var stages: Dictionary[int, PackedScene]
@export var black_screen: Polygon2D
@export var game_clock: Label
@export var timer: Timer

var player_reference: Player
var current_stage: TileMapLayer
var current_stage_number: int = 0
var elapsed_seconds: int = 0
var elapsed_minutes: int = 0
var elapsed_hours: int = 0

func _ready() -> void:
	initialize()

func initialize() -> void:
	connect_signals()
	spawn_player()
	load_stage(starting_stage)
	
func connect_signals() -> void:
	SignalBus.lay_to_rest.connect(stage_transition)
	timer.timeout.connect(increment_time)
	
func spawn_player() -> void:
	var new_player: Player
	
	new_player = player.instantiate()
	add_child(new_player)
	player_reference = new_player
	player_reference.initialize()

func load_stage(next_stage: int) -> void:
	var new_stage: Stage = stages[next_stage].instantiate()
	
	if current_stage != null:
		var tween = create_tween()
		tween.tween_property(current_stage, "modulate", Color(1,1,1,0), 0.25)
		tween.parallel().tween_property(player_reference, "modulate", Color(1,1,1,0), 0.25)
		
		await tween.finished
		current_stage.queue_free()
		
	SignalBus.place_player.emit(new_stage.get_spawn_position())
	player_reference.modulate = Color(1,1,1,1)
	await get_tree().process_frame
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

func increment_time() -> void:
	elapsed_seconds += 1
	if elapsed_seconds == 60:
		elapsed_minutes += 1
		elapsed_seconds = 0
	
	if elapsed_minutes == 60:
		elapsed_hours += 1
		elapsed_minutes = 0
		
	update_game_time()

func update_game_time() -> void:
	var mod_s: String
	var mod_m: String
	var mod_h: String
	
	if elapsed_seconds < 10:
		mod_s = "0" + str(elapsed_seconds)
	else:
		mod_s = str(elapsed_seconds)
		
	if elapsed_seconds < 10:
		mod_m = "0" + str(elapsed_minutes)
	else:
		mod_m = str(elapsed_minutes)
		
	if elapsed_seconds < 10:
		mod_h = "0" + str(elapsed_hours)
	else:
		mod_h = str(elapsed_hours)
	game_clock.text = mod_h + ":" + mod_m + ":" + mod_s
	pass
