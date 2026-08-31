extends CharacterBody2D
@onready var health_com: health_component = $HeathComponent

@onready var input_component: input_component = $input_component
@onready var movement_component: movement_component = $movement_component
@onready var progress_bar: ProgressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_com.health_changed.connect(update_health)
	progress_bar.value=health_com.health

func update_health(new_health: int) -> void:
	progress_bar.value=new_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var inputs:Array=input_component.update_input()
	movement_component.handle_inputs(inputs)
