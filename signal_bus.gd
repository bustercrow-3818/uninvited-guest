extends Node

@warning_ignore_start("unused_signal")
signal request_bounds
signal broadcast_bounds(bounds: Vector2)

signal possessed(victim: Node, mode: String)
signal release(victim: Node, mode: String)
