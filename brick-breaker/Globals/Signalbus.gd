extends Node

signal Tilehit

const GAME = preload("uid://b7ofnx4gvwjqs")

func load_game_scene()->void:
	get_tree().change_scene_to_packed(GAME)

func emit_tile_hit()->void:
	Tilehit.emit()
