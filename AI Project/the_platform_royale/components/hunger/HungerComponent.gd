class_name HungerComponent
extends Node

@export var max_hunger: float = 100.0
@export var decay_rate: float = 0.5 # hunger lost per second
var current_hunger: float = 100.0

var current_stage: String = "HIGH"

func _ready() -> void:
	current_hunger = max_hunger

func _process(delta: float) -> void:
	if current_hunger > 0.0:
		current_hunger = max(0.0, current_hunger - decay_rate * delta)
		_check_stage_update()
	else:
		# Starvation damage tick when at 0 hunger
		var health_comp = owner.get_node_or_null("HealthComponent")
		if health_comp:
			health_comp.take_damage(1.0 * delta)

func consume_food(amount: float) -> void:
	current_hunger = min(max_hunger, current_hunger + amount)
	_check_stage_update()

func _check_stage_update() -> void:
	var new_stage = CombatRules.get_hunger_stage_name(current_hunger)
	if new_stage != current_stage:
		current_stage = new_stage
		SignalBus.player_hunger_changed.emit(owner.name, current_hunger, current_stage)

func get_stage_modifiers() -> Dictionary:
	return CombatRules.get_hunger_stage_data(current_hunger)
