extends Node
class_name health_component

signal health_changed(new_health: int)
signal damaged(amount: int)
signal healed(amount: int)
signal died

@onready var body: CharacterBody2D = get_parent()

# Optional health resource
@export var data: health_res

# Fallback value if no health_res is assigned
@export var default_max_health: int = 100

var max_health: int
var invincible: bool = false
var is_dead: bool = false


var health: int:
	set(value):
		if value > max_health:
			health = max_health
		elif value <= 0:
			health = 0
			die()
		else:
			health = value

		health_changed.emit(health)


func _ready() -> void:
	# Use health_res if assigned,
	# otherwise use 100 HP.
	if data:
		max_health = data.max_health
	else:
		max_health = default_max_health

	health = max_health


func take_damage(amount: int) -> void:
	if invincible or is_dead:
		return

	if amount <= 0:
		return

	health -= amount
	damaged.emit(amount)


func take_health(amount: int) -> void:
	if is_dead:
		return

	if amount <= 0:
		return

	var old_health := health

	health += amount

	var actual_heal := health - old_health

	if actual_heal > 0:
		healed.emit(actual_heal)


func die() -> void:
	if is_dead:
		return

	is_dead = true
	died.emit()


func revive(amount: int = -1) -> void:
	if not is_dead:
		return

	is_dead = false

	if amount < 0:
		health = max_health
	else:
		health = clampi(amount, 1, max_health)


func full_heal() -> void:
	if is_dead:
		return

	health = max_health


func get_health_percent() -> float:
	if max_health <= 0:
		return 0.0

	return float(health) / float(max_health)


func set_max_health(value: int) -> void:
	if value <= 0:
		return

	max_health = value

	if health > max_health:
		health = max_health


func set_invincible(duration: float = 2.0) -> void:
	if invincible:
		return

	invincible = true

	print("I'm a god, fear me!")

	await get_tree().create_timer(duration).timeout

	invincible = false

	print("Lost my powers, sry")
