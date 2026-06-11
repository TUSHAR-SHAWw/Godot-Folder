extends Node

signal on_animal_died
signal on_cup_destroyed
signal on_attempt_made

func emit_attempt_made()->void:
	on_attempt_made.emit()

func emit_animal_died()->void:
	on_animal_died.emit()
	
func emit_cup_destroyed()->void:
	on_cup_destroyed.emit()
