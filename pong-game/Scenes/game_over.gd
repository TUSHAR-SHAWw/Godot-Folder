extends Control
@onready var wonlabel: Label = $MarginContainer/VBoxContainer/wonlabel
const GAME = preload("res://Scenes/game.tscn")
const LOADING = preload("res://Scenes/loading.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalhub.game_over.connect(on_game_over)


func on_game_over(pname)->void:
	show()
	wonlabel.text="%s WIN"% pname 
	get_tree().paused=true

func _on_button_pressed() -> void:
	hide()
	get_tree().change_scene_to_packed(LOADING)
