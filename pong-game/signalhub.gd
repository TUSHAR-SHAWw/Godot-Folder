extends Node

signal ball_die


# Called when the node enters the scene tree for the first time.
func emit_ball_die() -> void:
	ball_die.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
