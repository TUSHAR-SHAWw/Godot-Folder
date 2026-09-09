extends Node2D

@onready var player: Player = $Player
@onready var hud: CanvasLayer = $HUD

var floor_prefab = preload("res://floors/FloorBase.tscn")
var enemy_prefab = preload("res://entities/enemies/Enemy.tscn")
var ladder_prefab = preload("res://entities/interactables/Ladder.gd")

func _ready() -> void:
	print("[MainMatch] Spawning vertical tower floors and AI bots...")
	_spawn_vertical_tower_floors()
	_spawn_enemy_bots()
	RoundManager.start_match(100)

func _spawn_vertical_tower_floors() -> void:
	# Spawn 5 stacked floors vertically (spaced by 180 pixels)
	for f in range(1, 6):
		var floor_instance = floor_prefab.instantiate()
		floor_instance.position = Vector2(640, 600 - (f * 180))
		floor_instance.name = "TowerFloor_" + str(f)
		add_child(floor_instance)
		
		# Set floor label
		var lbl = floor_instance.get_node_or_null("FloorLabel")
		if lbl:
			lbl.text = "TOWER FLOOR #" + str(f) + " [Safe Zone]"

func _spawn_enemy_bots() -> void:
	# Spawn 3 AI bots on different floors
	for b in range(3):
		var bot = enemy_prefab.instantiate()
		bot.position = Vector2(400 + (b * 200), 400 - (b * 180))
		bot.name = "Bot_Agent_" + str(b + 1)
		add_child(bot)
