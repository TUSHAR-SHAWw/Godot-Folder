extends CharacterBody2D
@onready var health_com: health_component = $HeathComponent
@onready var input_com: input_component = $Input_Component

@onready var movement_com: movement_component = $movement_component
@onready var progress_bar: ProgressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_com.health_changed.connect(update_health)
	progress_bar.value=health_com.health

func update_health(new_health: int) -> void:
	progress_bar.value=new_health

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("damage"):
		#health_com.take_damage(20)
	#if event.is_action_pressed("heal"):
		#health_com.take_health(20)
	#if event.is_action_pressed("health"):
		#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var inputs:Array=input_com.update_input()
	movement_com.handle_inputs(inputs)
