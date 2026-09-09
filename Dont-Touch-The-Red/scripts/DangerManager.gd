extends Node2D

const DangerZone := preload("res://scripts/DangerZone.gd")

## Spawns danger zones on an interval using a set of random patterns.
## Every pattern always leaves at least one safe spot, so the game stays fair.

signal danger_spawned(zone)
signal danger_died

## Difficulty knobs (level tuning happens here, exposed for later scaling).
@export var spawn_interval := 2.2
@export var warning_time := 1.2
@export var active_time := 2.0

var running := false
var player: Node2D

# Arena half-size (matches the Arena node, +-400/+-300 around the origin).
var _arena_half := Vector2(400, 300)

func start(p: Node2D) -> void:
	player = p
	running = true
	_schedule()

func stop() -> void:
	running = false
	for child in get_children():
		if child is DangerZone:
			child.queue_free()

func _schedule() -> void:
	if not running:
		return
	await get_tree().create_timer(spawn_interval).timeout
	if not running:
		return
	_spawn_random_pattern()
	_schedule()

func _spawn_random_pattern() -> void:
	var patterns: Array[Callable] = [
		_pattern_side_rect,
		_pattern_strip,
		_pattern_expand,
	]
	patterns.pick_random().call()

func _spawn_zone(rect: Rect2, target := Vector2.ZERO, grow := 0.0) -> void:
	var zone := DangerZone.new()
	zone.setup(rect.size, target, warning_time, active_time, grow)
	zone.position = rect.get_center()
	add_child(zone)
	danger_spawned.emit(zone)

# ---------------------------------------------------------------------------
# Patterns: each returns a Rect2 in world space (arena centred on the origin).
# ---------------------------------------------------------------------------

func _pattern_side_rect() -> void:
	_spawn_zone(_random_side_rect())

func _random_side_rect() -> Rect2:
	var side := randi_range(0, 3)
	var half := _arena_half
	match side:
		0:  # left
			var w := half.x * randf_range(0.45, 0.6)
			return Rect2(Vector2(-half.x, -half.y), Vector2(w, half.y * 2.0))
		1:  # right
			var w := half.x * randf_range(0.45, 0.6)
			return Rect2(Vector2(half.x - w, -half.y), Vector2(w, half.y * 2.0))
		2:  # top
			var h := half.y * randf_range(0.45, 0.6)
			return Rect2(Vector2(-half.x, -half.y), Vector2(half.x * 2.0, h))
		_:  # bottom
			var h := half.y * randf_range(0.45, 0.6)
			return Rect2(Vector2(-half.x, half.y - h), Vector2(half.x * 2.0, h))

func _pattern_strip() -> void:
	_spawn_zone(_random_strip())

func _random_strip() -> Rect2:
	var vertical := randf() < 0.5
	var half := _arena_half
	if vertical:
		var thickness := randf_range(half.x * 0.25, half.x * 0.4)
		var x := randf_range(-half.x, half.x - thickness)
		return Rect2(Vector2(x, -half.y), Vector2(thickness, half.y * 2.0))
	else:
		var thickness := randf_range(half.y * 0.25, half.y * 0.4)
		var y := randf_range(-half.y, half.y - thickness)
		return Rect2(Vector2(-half.x, y), Vector2(half.x * 2.0, thickness))

func _pattern_expand() -> void:
	var half := _arena_half
	var start := Vector2(half.x * 0.08, half.y * 0.08)
	var target := Vector2(half.x * 0.9, half.y * 0.9)
	var center := Vector2(randf_range(-half.x * 0.15, half.x * 0.15), randf_range(-half.y * 0.15, half.y * 0.15))
	var rect := Rect2(center - start / 2.0, start)
	_spawn_zone(rect, target, 240.0)
