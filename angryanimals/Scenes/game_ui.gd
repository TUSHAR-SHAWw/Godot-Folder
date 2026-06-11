extends Control
@onready var vb_compete: VBoxContainer = $vb_compete
@onready var music: AudioStreamPlayer = $music
@onready var attempt_label: Label = $MarginContainer/HBoxContainer/vb2/AttemptLabel
@onready var levellabel: Label = $MarginContainer/HBoxContainer/vb2/Levellabel


var total_cups=0
var destroyed_cups=0
var total_attempts=-1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused=false
	on_attempt()
	Signalhub.on_cup_destroyed.connect(on_cup_destroyed)
	Signalhub.on_attempt_made.connect(on_attempt)
	total_cups=get_tree().get_nodes_in_group(cup.Group_name).size()
	print(total_cups)

func on_attempt()->void:
	total_attempts+=1
	attempt_label.text="%d" % total_attempts

func on_cup_destroyed()->void:
	destroyed_cups+=1
	if destroyed_cups==total_cups:
		vb_compete.show()
		music.play()
		get_tree().paused=true
