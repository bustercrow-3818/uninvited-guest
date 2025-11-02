extends Node

@warning_ignore_start("unused_signal")
signal request_bounds
signal broadcast_bounds(bounds: Vector2)
signal place_player(location: Vector2)
signal final_stage_end

signal possessed(victim: Node, mode: String)
signal release(victim: Node, mode: String)

signal turn_on_blocker(target: Node)
signal turn_off_blocker(target: Node)

signal lay_to_rest(body: Node)
