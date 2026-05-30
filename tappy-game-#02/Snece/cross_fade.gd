extends CanvasLayer
class_name crossfade
@onready var animation: AnimationPlayer = $Animation

func start_Animation()->void:
	animation.play("fade")


# Called when the node enters the scene tree for the first time.
func switch_scene()->void:
	Gamemanager.load_next_sceen()
