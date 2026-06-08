extends Area2D
@onready var splashsound: AudioStreamPlayer = $splashsound




func _on_body_entered(body: Node2D) -> void:
	if body is Animal:	
		splashsound.play()
		body.die()
