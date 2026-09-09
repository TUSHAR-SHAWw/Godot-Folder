class_name MovementComponent
extends Node

@export var move_speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 980.0

var velocity: Vector2 = Vector2.ZERO
var is_climbing: bool = false
var speed_multiplier: float = 1.0

func apply_movement(character: CharacterBody2D, input_dir: float, is_jump_pressed: bool, delta: float) -> void:
	if not character.is_on_floor() and not is_climbing:
		velocity.y += gravity * delta
	
	if is_climbing:
		velocity.y = input_dir * move_speed * 0.75
	else:
		velocity.x = input_dir * move_speed * speed_multiplier
		
		if is_jump_pressed and character.is_on_floor():
			velocity.y = jump_velocity
	
	character.velocity = velocity
	character.move_and_slide()
