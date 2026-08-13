extends Node

signal Tilehit(pos:Vector2)
signal Powerup(name:String)


const GAME = preload("uid://b7ofnx4gvwjqs")

func load_game_scene()->void:
	get_tree().change_scene_to_packed(GAME)

func emit_tile_hit(pos:Vector2=Vector2.ZERO)->void:
	Tilehit.emit(pos)

func emit_powerup(name:String)->void:
	Powerup.emit(name)
