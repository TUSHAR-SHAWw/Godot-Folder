class_name Ladder
extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	var move_comp = body.get_node_or_null("MovementComponent")
	if move_comp:
		move_comp.is_climbing = true

func _on_body_exited(body: Node2D) -> void:
	var move_comp = body.get_node_or_null("MovementComponent")
	if move_comp:
		move_comp.is_climbing = false
