extends Camera2D

## Keeps the whole arena in view on any screen size / aspect ratio.
## Recalculates zoom whenever the viewport is resized.

@export var arena_size := Vector2(800, 600)
@export var side_margin := 60.0
@export var bottom_margin := 40.0
@export var ui_top_reserve := 92.0  # HUD bar height in pixels at base 720

func _ready() -> void:
	_fit()
	get_viewport().size_changed.connect(_fit)

func _fit() -> void:
	var vp := get_viewport_rect().size
	if vp.x <= 0.0 or vp.y <= 0.0:
		return

	# Calculate world units needed. We must fit arena + margins.
	var needed := arena_size + Vector2(side_margin * 2.0, bottom_margin)
	
	# Initial estimate for zoom to determine HUD world height
	var z := minf(vp.x / needed.x, vp.y / needed.y)
	if z <= 0.0:
		return
		
	var hud_world := ui_top_reserve / z
	needed.y = arena_size.y + hud_world + bottom_margin
	
	# Final zoom calculation
	z = minf(vp.x / needed.x, vp.y / needed.y)
	zoom = Vector2(z, z)
