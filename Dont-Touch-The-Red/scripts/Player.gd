extends CharacterBody2D

## Simple circular player with smooth acceleration / deceleration.
## Controlled with WASD or the arrow keys.

@export_group("Movement")
@export var radius := 12.0
@export var max_speed := 420.0
@export var acceleration := 2000.0
@export var friction := 1800.0

# The world-space arena rect the player is clamped inside.
# The Arena node keeps its origin at the arena centre, so we derive this from it.
var arena_rect := Rect2(-400.0, -300.0, 800.0, 600.0)

var is_dead := false

func _ready() -> void:
	add_to_group("player")
	var collision := $CollisionShape2D
	if collision and collision.shape is CircleShape2D:
		collision.shape.radius = radius
	queue_redraw()

func die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	var main := get_tree().current_scene
	if main.has_method("_on_player_died"):
		main._on_player_died()
	queue_redraw()

func reset() -> void:
	is_dead = false
	velocity = Vector2.ZERO
	position = Vector2.ZERO
	queue_redraw()

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	var dir := _read_input()
	velocity = _update_velocity(velocity, dir, delta)
	move_and_slide()
	clamp_to_arena()

func _read_input() -> Vector2:
	var dir := Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT):
		dir.x -= 1.0
	if Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT):
		dir.x += 1.0
	if Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP):
		dir.y -= 1.0
	if Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN):
		dir.y += 1.0
	if dir != Vector2.ZERO:
		return dir.normalized()

	# Pointer steering: mouse or touch-drag (touch emulates the mouse).
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var to_target := get_global_mouse_position() - global_position
		if to_target.length() > 4.0:
			return to_target.normalized()
	return Vector2.ZERO

func _update_velocity(current: Vector2, dir: Vector2, delta: float) -> Vector2:
	if dir != Vector2.ZERO:
		return current.move_toward(dir * max_speed, acceleration * delta)
	return current.move_toward(Vector2.ZERO, friction * delta)

func clamp_to_arena() -> void:
	var min_x := arena_rect.position.x + radius
	var max_x := arena_rect.position.x + arena_rect.size.x - radius
	var min_y := arena_rect.position.y + radius
	var max_y := arena_rect.position.y + arena_rect.size.y - radius
	position.x = clampf(position.x, min_x, max_x)
	position.y = clampf(position.y, min_y, max_y)

func _draw() -> void:
	# Dark ball so it stands out against the white safe floor (turns red on death).
	var base := Color("#23232b")
	if is_dead:
		base = Color("#7a1d1d")
	draw_circle(Vector2.ZERO, radius, base)
	draw_circle(Vector2(-radius * 0.3, -radius * 0.35), radius * 0.55, Color("#3f3f4b"))
	draw_circle(Vector2(-radius * 0.2, -radius * 0.25), radius * 0.22, Color("#9c9cac"))
