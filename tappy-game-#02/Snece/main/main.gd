extends Control
@onready var hscorelabel: Label = $mc/Scorelabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hscorelabel.text=str(ScoreManager.high_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("power"):
		Gamemanager.load_game_sceen()
