extends Node2D
class_name Pipes
@onready var pipes: Node2D = $"."

@onready var ScoreSound: AudioStreamPlayer = $AudioStreamPlayer
const Speed:float=-120.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_local_x(delta*Speed)


func _on_screen_notifier_screen_exited() -> void:
	queue_free()


func _on_lifetimer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Tappy:
		Signalbus.emit_plane_die()


func _on_laser_body_exited(body: Node2D) -> void:
	if body is Tappy:
		Signalbus.emit_point_scored()
		ScoreSound.play()
		
