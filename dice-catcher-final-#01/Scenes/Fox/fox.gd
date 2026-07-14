extends Area2D
class_name fox
@export var speed:float=500.0
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sounds: AudioStreamPlayer2D = $sounds
signal pointscored
var direction:float=0
func _physics_process(delta: float) -> void:
	
	direction=Input.get_axis("ui_left","ui_right")
	if direction>0:
		sprite_2d.flip_h=true
	elif direction<0:
		sprite_2d.flip_h=false
	position.x+=delta*speed*direction


func _on_area_entered(area: Area2D) -> void:
	if area is Dice:
		sounds.play()
		area.queue_free()
		emit_signal("pointscored")
	
