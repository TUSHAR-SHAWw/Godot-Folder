extends TouchScreenButton



func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("up")):
		print("Helo")
	pass
