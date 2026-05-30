extends Node

const GAME = preload("res://Snece/Game/Game.tscn")
const MAIN = preload("res://Snece/main/main.tscn")
const CROSS_FADE = preload("res://Snece/cross_fade.tscn")
var cx:crossfade
var next_scene:PackedScene
func  _ready() -> void:
	cx=CROSS_FADE.instantiate()
	add_child(cx)
	

func load_next_sceen()->void:
	get_tree().change_scene_to_packed(next_scene)


func load_main_sceen()->void:
	next_scene=MAIN
	cx.switch_scene()
	
	
	
func load_game_sceen()->void:
	next_scene=GAME
	cx.switch_scene()
	
