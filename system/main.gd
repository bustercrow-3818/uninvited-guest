extends Node2D

@export var starting_stage: int
@export var player: PackedScene
@export var stages: Dictionary[int, PackedScene]
@export var black_screen: Polygon2D
@export var timer: Timer
@export var restart_button: Button
@export var bgm: AudioStreamPlayer2D
@export var game_clock: Label
@export var game_end_msg: Label

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
	load_stage(starting_stage, true)
	
func connect_signals() -> void:
	SignalBus.lay_to_rest.connect(stage_transition)
	restart_button.pressed.connect(restart_stage)
	timer.timeout.connect(increment_time)
	
func spawn_player() -> void:
	var new_player: Player
	
	if player_reference != null:
		player_reference.queue_free()
	
	new_player = player.instantiate()
	
	call_deferred("add_child", new_player)
	player_reference = new_player
	player_reference.initialize()

func load_stage(next_stage: int, initial: bool = false) -> void:
	var new_stage: Stage = stages[next_stage].instantiate()
	
	if initial == false:
		fade_out()
		await get_tree().create_timer(0.75).timeout
	else:
		pass
	
	spawn_player()
	
	if current_stage != null:
		current_stage.queue_free()
		
	current_stage = new_stage
	current_stage.initialize()
	SignalBus.place_player.emit(current_stage.get_spawn_position())
	fade_in()
	await get_tree().process_frame
	call_deferred("add_child", new_stage)

func stage_transition(body: Node) -> void:
	current_stage_number += 1
	
	if current_stage_number >= stages.size():
		game_end()
		SignalBus.final_stage_end.emit()
		
	elif body == player_reference:
		load_stage(current_stage_number)

func fade_out() -> void:
	if current_stage == null:
		return
		
	var tween = create_tween()
	tween.tween_property(current_stage, "modulate", Color(1,1,1,0), 0.25)
	tween.parallel().tween_property(restart_button, "modulate", Color(1,1,1,0), 0.25)
	tween.parallel().tween_property(player_reference, "modulate", Color(1,1,1,0), 0.25)
	await tween.finished

func fade_in() -> void:
	if current_stage == null:
		return
	
	var tween = create_tween()
	tween.tween_property(current_stage, "modulate", Color(1,1,1,1), 0.25)
	tween.parallel().tween_property(restart_button, "modulate", Color(1,1,1,1), 0.25)
	tween.parallel().tween_property(player_reference, "modulate", Color(1,1,1,1), 0.25)

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
		
	if elapsed_minutes < 10:
		mod_m = "0" + str(elapsed_minutes)
	else:
		mod_m = str(elapsed_minutes)
		
	if elapsed_hours < 10:
		mod_h = "0" + str(elapsed_hours)
	else:
		mod_h = str(elapsed_hours)
	game_clock.text = mod_h + ":" + mod_m + ":" + mod_s
	pass

func restart_stage() -> void:
	fade_out()
	load_stage(current_stage_number)

func game_end() -> void:
	timer.stop()
	game_end_msg.position = get_viewport_rect().size / 2
	fade_out()
	restart_button.disabled = true
	
	var tween = create_tween()
	tween.tween_property(game_end_msg, "modulate", Color(1,1,1,1), 3)
	
	pass
