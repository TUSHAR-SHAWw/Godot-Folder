extends Node2D
const PLAYER_1= preload("res://Scenes/player.tscn")
const BALL = preload("res://Scenes/ball.tscn")
const PLAYER_2 = preload("res://Scenes/player_2.tscn")
var Hearts=3
var viewport_size
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalhub.ball_die.connect(on_ball_die)
	viewport_size=get_viewport_rect().size
	spawn_players()
	spawn_ball()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_players():
	var player=PLAYER_1.instantiate()
	player.position=Vector2(50,viewport_size.y/2)
	add_child(player)
	var player2=PLAYER_2.instantiate()
	player2.position=Vector2(viewport_size.x-50,viewport_size.y/2)
	add_child(player2)

func spawn_ball():
	var newball=BALL.instantiate()
	newball.position=get_viewport_rect().get_center()
	add_child(newball)
func on_ball_die():
	Hearts-=0
	call_deferred("spawn_ball")
