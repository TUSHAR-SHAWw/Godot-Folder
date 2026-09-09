class_name PlayerController
extends Node

@export var player_node: Player

func _physics_process(delta: float) -> void:
	if player_node == null:
		return
	
	var input_x = Input.get_axis("ui_left", "ui_right")
	var is_jump = Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")
	
	if player_node.movement_component:
		player_node.movement_component.apply_movement(player_node, input_x, is_jump, delta)
