extends Node2D

@export var area: Area2D
@export var second_step_sign: Node

var second_step: bool = false

func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	SignalBus.possessed.connect(reveal_first)
	
func reveal_first(_node: Node, _string: String) -> void:
	var tween = create_tween()
	
	tween.tween_property(self, "modulate", Color(1,1,1,0.686), 0.15)
	SignalBus.possessed.disconnect(reveal_first)
	area.body_entered.connect(reveal_second)
	second_step = true

func reveal_second(_body: Node2D) -> void:
	var tween = create_tween()
	
	tween.tween_property(self, "modulate", Color(1,1,1,0), 0.15)
	tween.parallel().tween_property(second_step_sign, "modulate", Color(1,1,1,0.686), 0.15)
