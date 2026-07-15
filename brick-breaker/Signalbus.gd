extends Node

signal Tilehit


func emit_tile_hit()->void:
	Tilehit.emit()
