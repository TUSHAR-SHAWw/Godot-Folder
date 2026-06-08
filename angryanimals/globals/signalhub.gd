extends Node

signal on_animal_died

func emit_animal_died()->void:
	on_animal_died.emit()
