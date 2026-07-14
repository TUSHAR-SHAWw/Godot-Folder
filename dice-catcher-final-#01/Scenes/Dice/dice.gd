class_name Dice
extends Area2D
const speed:=200.0
const rotation_Speed:=3.0
@onready var image: Sprite2D = $image
var direction:=1
signal game_over
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randf()<0.5:
		direction=-1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	move_local_y(speed*delta)
	image.rotate(rotation_Speed*delta*direction)
	check_gameover()
	
	
func check_gameover()->void:
	if get_viewport_rect().end.y<position.y:
		game_over.emit()
		queue_free()
