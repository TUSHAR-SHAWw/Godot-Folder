extends Control

@onready var button: Button = $VBoxContainer/Button
@onready var button_2: Button = $VBoxContainer/Button2
@onready var button_3: Button = $VBoxContainer/Button3



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
