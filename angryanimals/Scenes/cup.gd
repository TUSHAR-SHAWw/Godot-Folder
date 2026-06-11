extends StaticBody2D
class_name cup
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const Group_name :String="Cup"
func _enter_tree() -> void:
	add_to_group(Group_name)

func die()->void:
	animation_player.play("vanish")
	Signalhub.emit_cup_destroyed()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
