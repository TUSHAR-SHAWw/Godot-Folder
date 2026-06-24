extends Control

@onready var p1_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/p1helth
@onready var p2_label: Label = $MarginContainer/HBoxContainer/VBoxContainer2/p2helth

var p1health:int
var p2health:int

func _ready() -> void:
	p1health=3
	p2health=3
	update_health(p1_label,p1health)
	update_health(p2_label,p2health)

func p1_get_damage()->void:
	p1health-=1
	update_health(p1_label,p1health)
	if p1health<=0:
		Signalhub.emit_game_over("Player 2")

func p2_get_damage()->void:
	p2health-=1
	update_health(p2_label,p2health)
	if p2health<=0:
		Signalhub.emit_game_over("Player 1")
		
func update_health(label:Label,health:int):
	label.text="❤".repeat(health)
