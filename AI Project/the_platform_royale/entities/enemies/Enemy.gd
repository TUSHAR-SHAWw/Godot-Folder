class_name Enemy
extends CharacterBody2D

enum AIState { LOOTING, HUNTING, FLEEING, FEEDING, RAGING }

@onready var health_component: HealthComponent = $HealthComponent
@onready var hunger_component: HungerComponent = $HungerComponent
@onready var combat_component: CombatComponent = $CombatComponent
@onready var movement_component: MovementComponent = $MovementComponent

var current_state: AIState = AIState.LOOTING
var target_entity: Node = null
var move_direction: float = 1.0
var state_timer: float = 0.0

func _ready() -> void:
	add_to_group("Enemies")
	add_to_group("Bots")

func _physics_process(delta: float) -> void:
	state_timer -= delta
	if state_timer <= 0:
		_update_ai_decisions()
		state_timer = randf_range(1.5, 3.0)
	
	if movement_component:
		movement_component.apply_movement(self, move_direction, false, delta)

func _update_ai_decisions() -> void:
	if hunger_component and hunger_component.current_stage == "RAGE":
		current_state = AIState.RAGING
		move_direction = 1.0 if randf() > 0.5 else -1.0
	else:
		# Alternate movement
		move_direction = -move_direction
