extends Area2D

@export var speed =200
@export var direction=1
@export var screenTime=1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(screenTime).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x+=delta*speed*direction



func playAnimation()->void:
	print("play")

func _on_body_entered(body: Node2D) -> void:
	if body is player:
		body.hit()
