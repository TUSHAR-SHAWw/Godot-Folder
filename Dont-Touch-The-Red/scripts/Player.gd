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
var _trail: Array[Vector2] = []
var skin_index := 0
var touch_enabled := false
var touch_vector := Vector2.ZERO
var _base_sprite_scale := Vector2.ONE

const SKIN_COLORS := [
	Color("#23232b"), Color("#147d92"), Color("#6d3bb5"), Color("#c27b16"), Color("#b83232"),
	Color("#2e8b57"), Color("#2374ab"), Color("#9b3d9b"), Color("#d05b2d"), Color("#4b5563"),
	Color("#0f766e"), Color("#be185d"), Color("#4d7c0f"), Color("#7c3aed"), Color("#b45309"),
	Color("#334155"), Color("#0891b2"), Color("#dc2626"), Color("#65a30d"), Color("#f59e0b")
]
const SKIN_HIGHLIGHTS := [
	Color("#3f3f4b"), Color("#35c5d8"), Color("#b184f0"), Color("#f3c567"), Color("#ff8b8b"),
	Color("#72d99a"), Color("#75bdf0"), Color("#e28be2"), Color("#ff9b6d"), Color("#aeb8c7"),
	Color("#5eead4"), Color("#f472b6"), Color("#bef264"), Color("#c4b5fd"), Color("#fbbf74"),
	Color("#94a3b8"), Color("#67e8f9"), Color("#fca5a5"), Color("#bef264"), Color("#fde68a")
]

var is_dead := false

@onready var player_sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("player")
	var arena := get_node_or_null("../Arena")
	if arena and arena.has_method("get_bounds"):
		arena_rect = arena.get_bounds()
	var collision := $CollisionShape2D
	if collision and collision.shape is CircleShape2D:
		collision.shape.radius = radius
	_base_sprite_scale = Vector2.ONE * radius * 2.0 / 64.0
	player_sprite.scale = _base_sprite_scale
	set_skin(skin_index)

func die() -> void:
	if is_dead:
		return
	var main := get_tree().current_scene
	if main.has_method("_try_consume_shield") and main._try_consume_shield():
		return
	is_dead = true
	velocity = Vector2.ZERO
	player_sprite.modulate = Color("#7a1d1d")
	if main.has_method("_on_player_died"):
		main._on_player_died()

func reset() -> void:
	is_dead = false
	velocity = Vector2.ZERO
	position = Vector2.ZERO
	_trail.clear()
	player_sprite.rotation = 0.0
	player_sprite.scale = _base_sprite_scale
	set_skin(skin_index)

func set_touch_vector(value: Vector2) -> void:
	touch_vector = value.limit_length(1.0)

func set_touch_enabled(enabled: bool) -> void:
	touch_enabled = enabled
	if not enabled:
		touch_vector = Vector2.ZERO

func set_skin(index: int) -> void:
	skin_index = clampi(index, 0, SKIN_COLORS.size() - 1)
	if is_instance_valid(player_sprite):
		player_sprite.modulate = Color("#7a1d1d") if is_dead else SKIN_COLORS[skin_index]

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	var dir := _read_input()
	velocity = _update_velocity(velocity, dir, delta)
	move_and_slide()
	clamp_to_arena()
	var speed_ratio := clampf(velocity.length() / max_speed, 0.0, 1.0)
	var motion_scale := Vector2(1.0 + speed_ratio * 0.10, 1.0 - speed_ratio * 0.06)
	player_sprite.scale = player_sprite.scale.lerp(_base_sprite_scale * motion_scale, minf(1.0, delta * 12.0))
	player_sprite.rotation += velocity.x * delta * 0.0015
	if velocity.length() > 20.0:
		_trail.push_front(position)
		if _trail.size() > 7:
			_trail.pop_back()

func _read_input() -> Vector2:
	var dir := Vector2.ZERO
	if touch_enabled and touch_vector != Vector2.ZERO:
		return touch_vector
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

