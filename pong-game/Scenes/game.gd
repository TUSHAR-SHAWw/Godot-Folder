extends Node2D
const PLAYER_1= preload("res://Scenes/player.tscn")
const BALL = preload("res://Scenes/ball.tscn")
const PLAYER_2 = preload("res://Scenes/player_2.tscn")
@onready var game_ui: Control = $"CanvasLayer/Game UI"
@onready var game_over: Control = $"CanvasLayer/Game Over"

var Hearts=3
var viewport_size
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalhub.ball_die.connect(on_ball_die)
	Signalhub.p1_damaged.connect(on_p1_damaged)
	Signalhub.p2_damaged.connect(on_p2_damaged)
	
	
	viewport_size=get_viewport_rect().size
	spawn_players()
	spawn_ball()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_players():
	var player=PLAYER_1.instantiate()
	add_child(player)
	player.position=Vector2(100,viewport_size.y/2)
	var player2=PLAYER_2.instantiate()
	add_child(player2)
	player2.position=Vector2(viewport_size.x-100,viewport_size.y/2)

func spawn_ball():
	var newball=BALL.instantiate()
	newball.position=get_viewport_rect().get_center()
	add_child(newball)
func on_ball_die():
	Hearts-=0
	call_deferred("spawn_ball")
func on_p1_damaged():
	game_ui.p1_get_damage()
func on_p2_damaged():
	game_ui.p2_get_damage()
