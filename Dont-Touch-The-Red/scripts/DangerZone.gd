extends Area2D

## A single dangerous red area. Lives through warning -> active -> done.
## While WARNING the zone is only a translucent pulsing preview (not lethal).
## Once ACTIVE it becomes solid red and kills the player on contact.

signal warning_started
signal activated
signal finished

enum Phase { WARNING, ACTIVE, DONE }

@export var warning_time := 1.2
@export var active_time := 2.0

var size_now := Vector2(200, 200)
var target_size := Vector2.ZERO
var grow_speed := 0.0

var phase := Phase.WARNING

const WARNING_COLOR := Color("#8a1616")
const ACTIVE_COLOR := Color("#e02323")
const ACTIVE_BORDER := Color("#6d0d0d")

var _shape: RectangleShape2D
var _collider: CollisionShape2D

## Configure the zone before adding it to the tree.
func setup(new_size: Vector2, target: Vector2, warn: float, act: float, grow: float) -> void:
	size_now = new_size
	target_size = target
	warning_time = warn
	active_time = act
	grow_speed = grow

func _ready() -> void:
	_shape = RectangleShape2D.new()
	_collider = CollisionShape2D.new()
	_collider.shape = _shape
	_collider.disabled = true
	add_child(_collider)

	# Detect the player (PhysicsBody2D on collision layer 1).
	collision_layer = 0
	collision_mask = 1
	monitoring = true
	monitorable = false

	body_entered.connect(_on_body_entered)
	warning_started.emit()
	_start_warning()

func _start_warning() -> void:
	phase = Phase.WARNING
	get_tree().create_timer(warning_time).timeout.connect(_activate)
	queue_redraw()

func _activate() -> void:
	phase = Phase.ACTIVE
	_update_collider()
	activated.emit()
	queue_redraw()
	get_tree().create_timer(active_time).timeout.connect(_finish)

func _finish() -> void:
	phase = Phase.DONE
	finished.emit()
	queue_free()

func _physics_process(delta: float) -> void:
	if target_size != Vector2.ZERO and size_now != target_size:
		size_now = size_now.move_toward(target_size, grow_speed * delta)
		if phase != Phase.WARNING:
			_update_collider()
		queue_redraw()

	if phase == Phase.ACTIVE:
		for body in get_overlapping_bodies():
			if body.is_in_group("player") and body.has_method("die"):
				body.die()

func _update_collider() -> void:
	_shape.size = size_now
	_collider.set_deferred("disabled", false)

func _on_body_entered(body: Node) -> void:
	if phase == Phase.ACTIVE and body.is_in_group("player") and body.has_method("die"):
		body.die()

func _draw() -> void:
	var rect := Rect2(-size_now / 2.0, size_now)
	if phase == Phase.WARNING:
		var t := Time.get_ticks_msec() / 1000.0
		var pulse := 0.5 + 0.5 * sin(t * TAU * 2.0)
		var fill := WARNING_COLOR
		fill.a = 0.20 + 0.30 * pulse
		draw_rect(rect, fill)
		var border := WARNING_COLOR
		border.a = 0.4 + 0.6 * pulse
		draw_rect(rect, border, false, 3.0 + 2.0 * pulse)
	else:
		draw_rect(rect, ACTIVE_COLOR)
		draw_rect(rect, ACTIVE_BORDER, false, 4.0)
