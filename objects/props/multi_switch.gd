extends Switch

func toggle(body: Node) -> void:
	if body is not Entity:
		return
	
	if body.get_move_instruction() is PossessedMovement:
		for i in controlled_barrier:
			SignalBus.turn_off_blocker.emit(i)
		on.hide()
		off.show()
	elif body is Player:
		for i in controlled_barrier:
			SignalBus.turn_on_blocker.emit(i)
		on.show()
		off.hide()
