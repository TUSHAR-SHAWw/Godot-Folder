extends RigidBody2D
@onready var label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		freeze=false
	if event.is_action_pressed("ui_up"):
		freeze=false
		apply_central_impulse(Vector2(200,-200))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text	="Freeze:%s\nContact count:%s\nSleeping%s" %[freeze,get_contact_count(),sleeping]


func _on_sleeping_state_changed() -> void:
	print(sleeping) # Replace with function body.


func _on_body_entered(body: Node) -> void:
	pass # Replace with function body.


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouse and event.button_mask==1:
		position=get_global_mouse_position()
