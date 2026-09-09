extends RigidBody2D
@onready var arrow: Sprite2D = $Arrow
@onready var label: Label = $Label
@onready var stretch_sound: AudioStreamPlayer = $StretchSound
@onready var launch_sound: AudioStreamPlayer = $LaunchSound
@onready var kick_sound: AudioStreamPlayer = $KickSound
@export var launch_speed:int =10
var is_dragging:bool=false
var is_launched:bool=false
var start_drag_pos:Vector2
var animal_start:Vector2
var drag_diff:Vector2
func _physics_process(delta: float) -> void:
	label.text="Freeze:  %s \n Contact Count%s \n Sleeping:  %s"%[
		freeze, 
		get_contact_count(),
		sleeping]	
	if is_dragging:
		draganimal()
	if is_launched:
		launchanimal()

func launchanimal()->void:
	arrow.hide()
	is_launched=false
	freeze=false
	InputMap.erase_action("click")
	var launch_power=launch_speed*drag_diff
	linear_velocity=launch_power
	

func draganimal()->void:
	arrow.show()
	drag_diff=(start_drag_pos -get_global_mouse_position()).limit_length(100)
	arrow.rotation=drag_diff.angle()
	arrow.scale.x=clamp(drag_diff.length()/50,.5,2)
	position=animal_start-drag_diff

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !is_launched:
		if event.is_action_pressed("click"):
			start_drag_pos = get_global_mouse_position()
			animal_start = position
			is_dragging = true
			stretch_sound.play()
		
func _input(event: InputEvent) -> void:
	if !is_launched and is_dragging:
		if event.is_action_released("click"):
				launch_sound.play()
				is_dragging=false
				is_launched=true

func _ready() -> void:
	arrow.hide()
