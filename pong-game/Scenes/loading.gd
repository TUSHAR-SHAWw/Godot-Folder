extends Control
@onready var timer: Timer = $Timer
var GAME = load("res://Scenes/game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	get_tree().paused=false
	get_tree().change_scene_to_packed(GAME)
