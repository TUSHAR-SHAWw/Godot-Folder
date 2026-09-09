class_name HUD
extends CanvasLayer

@onready var health_bar: ProgressBar = $VBoxContainer/HealthBar
@onready var hunger_bar: ProgressBar = $VBoxContainer/HungerBar
@onready var floor_label: Label = $TopBar/FloorLabel
@onready var alive_label: Label = $TopBar/AliveLabel

func _ready() -> void:
	SignalBus.player_health_changed.connect(_on_health_changed)
	SignalBus.player_hunger_changed.connect(_on_hunger_changed)
	SignalBus.round_started.connect(_on_round_started)

func _on_health_changed(player_id: String, cur: float, max_val: float) -> void:
	if health_bar:
		health_bar.max_value = max_val
		health_bar.value = cur

func _on_hunger_changed(player_id: String, cur: float, stage: String) -> void:
	if hunger_bar:
		hunger_bar.value = cur
		if stage == "RAGE":
			hunger_bar.modulate = Color(1, 0, 0)
		else:
			hunger_bar.modulate = Color(1, 0.8, 0.2)

func _on_round_started(round_num: int, alive: int, floors: int) -> void:
	if floor_label:
		floor_label.text = "Tower Floors: " + str(floors)
	if alive_label:
		alive_label.text = "Alive: " + str(alive)
