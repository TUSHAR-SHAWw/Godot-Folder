extends Node2D
@onready var brick_map: TileMapLayer = $BrickMap
const BRICKBASE = preload("uid://b0nya1v3cgehq")
@onready var brick_container: Node2D = $BrickContainer


func _ready() -> void:
	for i in brick_map.get_used_cells():
		var pos=brick_map.to_global(brick_map.map_to_local(i))
		spawn_brick(pos)
	brick_map.queue_free()

func spawn_brick(position:Vector2)->void:
	var newBrick : Brick=BRICKBASE.instantiate()
	brick_container.add_child(newBrick)
	newBrick.global_position=position
	
