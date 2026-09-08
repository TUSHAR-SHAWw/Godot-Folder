extends CharacterBody2D
@onready var health_com: health_component = $HeathComponent
@onready var input_com: input_component = $Input_Component
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var movement_com: movement_component = $movement_component
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var tween:Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween=Tween.new()
	health_com.health_changed.connect(update_health)
	movement_com.jumped.connect(jumpAnimation)
	movement_com.landed.connect(landAnimation)
	
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
	if inputs[1]:
		print("jumping")
		
	
func jumpAnimation() -> void:
	if tween.is_valid():
		tween.kill()
	tween=create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite_2d,"scale",Vector2(.7,1.3),.06)
	tween.tween_property(sprite_2d,"scale",Vector2(1,1),.1)
	

func landAnimation() -> void:
	if tween.is_valid():
		tween.kill()
	tween=create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite_2d, "scale", Vector2(1.15, 0.85), 0.08)
	tween.tween_property(sprite_2d, "scale", Vector2(1, 1), 0.12)
