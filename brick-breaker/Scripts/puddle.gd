extends StaticBody2D
class_name Puddle
var direction:int=0
var Speed:int=200


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_pressed("left"):
		direction=-1
	if Input.is_action_pressed("right"):
		direction=1
	position.x+=direction*Speed*delta
	position.x=clamp(position.x,28,get_viewport_rect().size.x-28)
	direction=0
	
	
