extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Ball:
		await get_tree().create_timer(1.0).timeout

		if is_instance_valid(body):
			body.queue_free()
			print("out")#
