extends RigidBody2D
class_name Animal
@onready var stretchsound: AudioStreamPlayer = $Stretchsound
@onready var label: Label = $Label
@onready var arrow: Sprite2D = $Arrow
@onready var launchsound: AudioStreamPlayer = $Launchsound
@onready var kick_sound: AudioStreamPlayer = $KickSound

const Max_drag_x:Vector2=Vector2(-60,0)
const Max_drag_y:Vector2=Vector2(0,60)
const IMPULSE_MULT:float=25
const IMPULSE_MAX:float=2000

var _arrow_scale_x:float=0
var _start:Vector2=Vector2.ZERO #bird start pos
var _drag_start:Vector2=Vector2.ZERO #mouse click start pos
var _dragged:Vector2=Vector2.ZERO #mouse start - Current mouse pos
var _is_dragging:bool=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start=position
	_arrow_scale_x=arrow.scale.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = """
	Freeze: %s
	Sleeping: %s
	Dragging: %s

	Position: %.1f, %.1f
	Start: %.1f, %.1f

	Mouse: %.1f, %.1f
	Drag Start: %.1f, %.1f
	Dragged: %.1f, %.1f

	Contacts: %d
	Velocity: %.1f

	Impulse: %.1f, %.1f
	Impulse Len: %.1f
	Arrow Scale: %.2f
	""" % [
		freeze,
		sleeping,
		_is_dragging,

		position.x,
		position.y,

		_start.x,
		_start.y,

		get_global_mouse_position().x,
		get_global_mouse_position().y,

		_drag_start.x,
		_drag_start.y,

		_dragged.x,
		_dragged.y,

		get_contact_count(),
		linear_velocity.length(),

		calculate_impulse().x,
		calculate_impulse().y,
		calculate_impulse().length(),

		arrow.scale.x
	]

func startdragging()->void:
	arrow.show()
	_is_dragging=true
	_drag_start=get_global_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	if _is_dragging and event.is_action_released("drag"):
		
		call_deferred("start_release")

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("drag"):
		input_event.disconnect(_on_input_event)
		startdragging()

func start_release()->void:
	launchsound.play()
	arrow.show()
	_is_dragging=false
	freeze=false
	apply_central_impulse(calculate_impulse())

func handle_dragging()->void:
	var _new_dragged=get_global_mouse_position()-_drag_start
	_new_dragged=_new_dragged.clamp(Max_drag_x,Max_drag_y)
	var diff:Vector2=_new_dragged-_dragged
	if diff.length()>0 and !stretchsound.playing:
		stretchsound.play()
	_dragged=_new_dragged
	position=_start+_dragged
	
func _physics_process(_delta: float) -> void:
	if _is_dragging:
		handle_dragging()
		scale_arrow()
		
func calculate_impulse()->Vector2:
	return _dragged*IMPULSE_MULT*-1

func scale_arrow() -> void:
	var power = calculate_impulse().length() / IMPULSE_MAX
	power = clamp(power, 0.0, 1.0)
	arrow.scale.x = _arrow_scale_x + power
	arrow.rotation = (_start - position).angle()

func die()-> void:
	Signalhub.emit_animal_died()
	queue_free()
	
#func scale_arrow() -> void:
	#var new_scale:float=clamp((calculate_impulse().length())/IMPULSE_MAX,_arrow_scale_x,0.9)
	#arrow.scale.x=new_scale
	#arrow.rotation = (_start - position).angle()


func _on_body_entered(body: Node) -> void:
	if body is StaticBody2D and !kick_sound.playing:
		kick_sound.play()


func _on_sleeping_state_changed() -> void:
	if sleeping:
		for body in get_colliding_bodies():
			if body is cup:
				body.die()
		die()
