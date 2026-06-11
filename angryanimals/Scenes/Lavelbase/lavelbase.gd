extends Node
@onready var marker_2d: Marker2D = $Marker2D

const Animalscene = preload("res://Scenes/animal.tscn")
const MAIN = preload("res://Scenes/Main/main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalhub.on_animal_died.connect(spawn_animal)
	spawn_animal() # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_packed(MAIN)

func spawn_animal()->void:
	var new_animal:Animal=Animalscene.instantiate()
	new_animal.position=marker_2d.position
	call_deferred("add_child",new_animal)
	print("spawned")
