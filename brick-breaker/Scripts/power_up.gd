extends Area2D
class_name Powerup
var speed=50
var Powerups:Array=["wide","split2","speed"]
var powername
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	powername=Powerups.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y+=speed*delta
	if position.y >get_viewport().get_visible_rect().size.y+10:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Puddle:
		Signalbus.emit_powerup(powername)
