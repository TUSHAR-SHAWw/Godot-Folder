extends Control
@onready var score: Label = $MarginContainer/Score
@onready var gameover: Label = $MarginContainer/gameover
@onready var spacebar: Label = $MarginContainer/Spacebar
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalbus.point_scored.connect(update_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_score() -> void:
	ScoreManager.high_score=ScoreManager.points
	score.text=str(ScoreManager.points)
func show_ui() -> void:
	
	gameover.visible=true
	timer.start()
	

func _unhandled_input(event: InputEvent) -> void:
	if spacebar.visible and event.is_action_pressed("power"):
		get_tree().paused=false
		Gamemanager.load_game_sceen()
		

func _on_timer_timeout() -> void:
	gameover.visible=false
	spacebar.visible=true
