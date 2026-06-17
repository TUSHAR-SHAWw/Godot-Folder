extends CharacterBody2D

class_name Player

@export var Speed =30000
var direction=0
# Called when the node enters the scene tree for the first time. 
func _ready() -> void:
	pass

func setinputvelocity(delta):
	direction=0
	velocity.y=0
	if Input.is_action_pressed("up"):
		direction=-1
	if Input.is_action_pressed("down"):
		direction=1
	velocity.y=Speed*delta*direction
	move_and_slide()

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	setinputvelocity(delta)
	
	
	
	
