class_name Brick
extends StaticBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D


const ROWS := [75, 139, 199]
const COLUMNS := [897, 1016, 1136, 1251]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(sprite_2d.region_rect)
	sprite_2d.region_rect=Rect2(
		COLUMNS.pick_random(),
		ROWS.pick_random(),
		116,
		56)
