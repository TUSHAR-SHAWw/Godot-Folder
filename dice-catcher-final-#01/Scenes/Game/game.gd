extends Node2D

var Score:int=0
const stoppable:String="stoppable"
const GAME_OVER = preload("uid://bew3hhlg7etw7")
const DICE = preload("uid://b0rtrfabp7p7c")

@onready var pauseble: Node = $Pauseble
@onready var score: Label = $Score_label
@onready var music: AudioStreamPlayer = $Music
@onready var timer: Timer = $Pauseble/Timer


func _ready() -> void:
	update_score_label()
	get_tree().paused=false
	spawn_dice()
func _unhandled_input(event:InputEvent ) -> void:
	if event.is_action_pressed("SpawnDice",true):
		spawn_dice()
		print("Spawned")
	if event.is_action_pressed("Restart"):
		get_tree().reload_current_scene()

func spawn_dice() ->void:
	var new_dice:Dice=DICE.instantiate()
	var rand_x:float=randf_range(20,get_viewport_rect().end.x-20)
	
	new_dice.position=Vector2(rand_x,0)
	new_dice.game_over.connect(_on_dice_game_over)
	pauseble.add_child(new_dice)
	
func _on_dice_game_over() -> void:
	#pause_all()
	timer.stop()
	print("Game Over")
	music.stop()
	music.stream=GAME_OVER
	music.play()
	get_tree().paused=true
func pause_all() ->void:
	var to_stop:Array[Node]=get_tree().get_nodes_in_group(stoppable)
	for item in to_stop:
		item.set_physics_process(false)

func _process(delta: float) -> void:
	pass



func _on_timer_timeout() -> void:
	spawn_dice()

func update_score_label()->void:
	score.text="Score:%d" % Score

func _on_fox_pointscored() -> void:
	Score+=10
	update_score_label()
	
