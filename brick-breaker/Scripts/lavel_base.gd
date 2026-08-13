extends Node2D
@onready var brick_map: TileMapLayer = $BrickMap
@onready var brick_container: Node2D = $BrickContainer
@export var BrickCount:int=0
@onready var game_ui: Control = $"Ui Container"/Game_UI
@onready var ui_container: CanvasLayer = $"Ui Container"
const BRICKBASE = preload("uid://b0nya1v3cgehq")
const GAME_WON = preload("uid://ccmchpcgepm5o")
const POWER_UP = preload("uid://cp68c2blu5h13")

func _ready() -> void:
	Signalbus.Tilehit.connect(on_tile_hit)
	Signalbus.Powerup.connect(on_power_up)
	
	for i in brick_map.get_used_cells():
		var pos:Vector2=brick_map.to_global(brick_map.map_to_local(i))
		spawn_brick(pos)
	brick_map.queue_free()
	game_ui.change_brike_label(BrickCount)
	print(BrickCount)

func spawn_brick(position:Vector2)->void:
	var newBrick : Brick=BRICKBASE.instantiate()
	brick_container.add_child(newBrick)
	newBrick.global_position=position
	BrickCount+=1
	
func on_tile_hit(pos)->void:
	BrickCount-=1
	game_ui.change_brike_label(BrickCount)
	if BrickCount<=0:
		var win_ui=GAME_WON.instantiate()
		ui_container.add_child(win_ui)
	if randf()<0.2:
		spawn_powerup(pos)
		

func spawn_powerup(pos:Vector2)->void:
	var newpowerup:Powerup=POWER_UP.instantiate()
	newpowerup.position=pos
	add_child(newpowerup)

func on_power_up(name)->void:
	print(name)
