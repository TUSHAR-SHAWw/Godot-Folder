extends Node2D
var dir=1
const speed =60
@onready var ray_cast_r: RayCast2D = $RayCastR
@onready var ray_cast_l: RayCast2D = $RayCastL
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	if( ray_cast_l.is_colliding()):
		dir=1
		animated_sprite_2d.flip_h=false
	if( ray_cast_r.is_colliding()):
		dir=-1
		animated_sprite_2d.flip_h=true
	position.x+=delta*speed*dir
