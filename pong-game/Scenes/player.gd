extends CharacterBody2D

class_name Player

@export var Speed :int=600
var direction:int
var startx:float

#func _ready() -> void:
	#call_deferred("setstartx")
	#

func setinputvelocity(delta): 
	direction=0
	
	if Input.is_action_pressed("up"):
		direction=-1
	if Input.is_action_pressed("down"):
		direction=1
	velocity=Vector2(0,Speed*direction)
	move_and_slide()
	
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	setinputvelocity(delta)
	
