extends Node
class_name movement_component
@onready var parent:CharacterBody2D=get_parent()
@onready var sprite:CharacterBody2D=get_parent().get_node("sprite2d")
@export var speed:float=100
@export var is_jumping=false
@export var jump_power=-300
@export var coyote_time:float=.12
@export var can_Jump=true
@export var can_wall_jump=true
@export var use_gravity := true
@export var wall_jump_speed := 70.0
@export var wall_jump_lock_time := 0.15
var tween :Tween
var wall_jump_timer := 0.0
var coyote_timer:float=0
var direction:Vector2
var was_on_floor=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	#parent.global_position.x+=direction[0]*speed*delta
	#parent.global_position.y+=direction[1]*speed*delta
	if parent.is_on_floor():
		coyote_timer=coyote_time
	else:
		coyote_timer-=delta
	if use_gravity and not parent.is_on_floor():
		parent.velocity+=parent.get_gravity()*delta
	wall_jump_timer-=delta
	if wall_jump_timer<0:
		parent.velocity.x=direction[0]*speed
	jump()
	parent.move_and_slide()
	if not was_on_floor and parent.is_on_floor():
		land_animation()

func land_animation():
	print("land")
	tween=Tween.new()
	#tween.tween_property(parent)
	pass

func jump() -> void:
	if not can_Jump or not is_jumping:
		return

	if coyote_timer > 0:
		parent.velocity.y = jump_power
		coyote_timer = 0
		was_on_floor=true

	elif can_wall_jump and parent.is_on_wall():
		wall_jump_timer = wall_jump_lock_time
		parent.velocity.y = jump_power
		parent.velocity.x = parent.get_wall_normal().x * wall_jump_speed
		

func handle_inputs(inputs: Array) -> void:
	direction=inputs[0]
	is_jumping=inputs[1]
