extends Node
class_name InputComponent
var inputs={"Left":KEY_D,"Right":KEY_A,"Up":KEY_W,"Down":KEY_S}
	
func set_Inputs():
	for input in inputs:
		if not InputMap.has_action(input):
			InputMap.add_action(input)
		var event=InputEventKey.new()
		event.physical_keycode=inputs[input]
		if not InputMap.action_has_event(input, event):
			InputMap.action_add_event(input, event)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_Inputs()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
