extends Area2D
@onready var anp: AnimationPlayer = $AnimationPlayer

@onready var gamemanager: Node = %gamemanager


func _on_body_entered(body: Node2D) -> void:
	gamemanager.add_point()
	print("cooin")
	anp.play("pickup")
	
