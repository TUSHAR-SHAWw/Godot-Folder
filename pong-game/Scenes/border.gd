extends Area2D
class_name border
@onready var maxup: CollisionShape2D = $maxup
@onready var maxdown: CollisionShape2D = $maxdown
@onready var dangerleft: Area2D = $dangerleft
@onready var dangerright: Area2D = $dangerright
func _ready() -> void:
	resize_borders()


func _on_danger_body_entered(body: Node2D) -> void:
	if body is Ball:
		Signalhub.emit_ball_die()
		body.queue_free()

func resize_borders():
	var size = get_viewport_rect().size
	maxup.position = Vector2(size.x/2,0)
	maxdown.position = Vector2(size.x/2,size.y)
	dangerright.position.x = size.x
	dangerright.position.y = size.y/2
	dangerleft.position.x = 0
	dangerleft.position.y = size.y/2
