class_name Player
extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var hunger_component: HungerComponent = $HungerComponent
@onready var combat_component: CombatComponent = $CombatComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var inventory_component: InventoryComponent = $InventoryComponent
@onready var equipment_component: EquipmentComponent = $EquipmentComponent

@export var current_floor_id: int = 1

func _ready() -> void:
	add_to_group("Players")
	print("[Player] Registered player entity: ", name)

func _physics_process(delta: float) -> void:
	# Handled via PlayerController or AI
	pass
