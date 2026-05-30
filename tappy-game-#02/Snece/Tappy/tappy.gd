extends CharacterBody2D
class_name Tappy
var _jumped:bool=false
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const _jumpPower:float=-350.0
var _gravity:float=ProjectSettings.get("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("power"):
		_jumped=true
		animation_player.play("jump")
		get_viewport().set_input_as_handled()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.y+=_gravity*delta
	if _jumped:
		velocity.y=_jumpPower
		_jumped=false
	if is_on_floor():
		Signalbus.emit_plane_die()
	move_and_slide()
