class_name HealthComponent
extends Node

@export var max_health: float = 100.0
var current_health: float = 100.0
var is_dead: bool = false

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float, attacker: Node = null) -> void:
	if is_dead:
		return
	
	current_health = max(0.0, current_health - amount)
	SignalBus.player_health_changed.emit(owner.name, current_health, max_health)
	
	if current_health <= 0.0:
		is_dead = true
		SignalBus.entity_died.emit(owner, attacker)

func heal(amount: float) -> void:
	if is_dead:
		return
	current_health = min(max_health, current_health + amount)
	SignalBus.player_health_changed.emit(owner.name, current_health, max_health)
