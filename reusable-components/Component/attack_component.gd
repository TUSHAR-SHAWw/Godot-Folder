extends Node

@export var damage=20


func _ready() -> void:
	pass # Replace with function body.


func attack(body) -> void:
	body.take_damage(20)
