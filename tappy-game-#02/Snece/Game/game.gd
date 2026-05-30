extends Node
const Pipescene=preload("res://Snece/Pipe/pipes.tscn")
@onready var spawn_timer: Timer = $SpawnTimer
@onready var upper_spawn: Marker2D = $UpperSpawn
@onready var lower_spawn: Marker2D = $LowerSpawn
@onready var pipes_holder: Node = $PipesHolder
@onready var game_ui: Control = $CanvasLayer/Game_UI

const spawntime:float=1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	spawn_timer.wait_time=spawntime
	Signalbus.plane_die.connect(place_died)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Gamemanager.load_main_sceen()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	spawn_pipe()
	
func spawn_pipe()-> void:
	var pipe_position:Vector2=Vector2(lower_spawn.position.x,randf_range(upper_spawn.position.y,lower_spawn.position.y))
	var new_pipees =Pipescene.instantiate()
	new_pipees.position=pipe_position
	pipes_holder.add_child(new_pipees)
	
func place_died()->void:
	game_ui.show_ui()
	get_tree().paused=true
	
