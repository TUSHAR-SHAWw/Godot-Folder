extends Node

signal ball_die
signal p1_damaged
signal p2_damaged
signal game_over(name)
# Called when the node enters the scene tree for the first time.
func emit_ball_die() -> void:
	ball_die.emit()
	
func emit_game_over(name:String) -> void:
	game_over.emit(name)

func emit_p1_damaged() -> void:
	p1_damaged.emit()
	
func emit_p2_damaged() -> void:
	p2_damaged.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
