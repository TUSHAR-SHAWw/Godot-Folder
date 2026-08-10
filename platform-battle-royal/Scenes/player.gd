extends CharacterBody2D
class_name player
@onready var anispr: AnimatedSprite2D = $anispr

const SPEED = 110.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("up"):
		direction.y -= 1
		anispr.animation="upani"
	if Input.is_action_pressed("down"):
		direction.y += 1
		anispr.animation="downani"
	if Input.is_action_pressed("left"):
		direction.x -= 1
		anispr.animation="leftani"
	if Input.is_action_pressed("right"):
		direction.x += 1
		anispr.animation="rightani"

	direction = direction.normalized()
	velocity = direction * SPEED
	
	move_and_slide()
