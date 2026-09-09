extends Node2D

## The play field. White floor = safe. Black border = the arena walls.
## Kept intentionally simple for the MVP.

@export var arena_size := Vector2(800, 600)
@export var border_width := 6.0

## Returns the playable area in world space (relative to this node's origin,
## which is the arena centre).
func get_bounds() -> Rect2:
	return Rect2(-arena_size / 2.0, arena_size)

func _draw() -> void:
	var half := arena_size / 2.0
	# Safe floor.
	draw_rect(Rect2(-half, arena_size), Color("#f2f2f5"))
	# Border (walls).
	draw_rect(Rect2(-half - Vector2(border_width, border_width), arena_size + Vector2(border_width, border_width) * 2.0), Color("#141419"), false, border_width)
