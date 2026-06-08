extends StaticBody2D
class_name cup
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func die()->void:
	animation_player.play("vanish")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
