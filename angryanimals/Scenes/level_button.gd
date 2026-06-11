extends TextureButton
@onready var level_label: Label = $MarginContainer/vb/LevelLabel
@onready var best_score_label: Label = $MarginContainer/vb/BestScoreLabel

@export var Levelnumber:int=1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_label.text=str(Levelnumber)



func _on_mouse_entered() -> void:
	scale=Vector2(1.1,1.1)


func _on_mouse_exited() -> void:
	scale=Vector2(1.0,1.0)


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Lavelbase/Lavel%d.tscn" %Levelnumber)
