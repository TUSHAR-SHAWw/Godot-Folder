extends Node

class_name input_component
var input_array:Array
const inputs:={
	"up":KEY_W,
	"down":KEY_S,
	"left":KEY_A,
	"right":KEY_D,
	"jump":KEY_SPACE
}

func _ready() -> void:
	setupinputs()

func update_input()->Array:
	
	return [move_input(),jump_input()]

func move_input()->Vector2:
	var direction=Input.get_vector("left","right","up","down",)
	return direction

func jump_input()->bool:
	return Input.is_action_just_pressed("jump")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		input_array.append(event)
	
func setupinputs() -> void:
	for action in inputs:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			var key=InputEventKey.new()
			key.physical_keycode=inputs[action]
			InputMap.action_add_event(action,key)
