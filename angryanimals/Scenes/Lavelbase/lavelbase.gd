extends Node2D
@onready var marker_2d: Marker2D = $Marker2D
const Animalscene = preload("res://Scenes/animal.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalhub.on_animal_died.connect(spawn_animal)
	spawn_animal() # Replace with function body.


func spawn_animal()->void:
	var new_animal:Animal=Animalscene.instantiate()
	new_animal.position=marker_2d.position
	call_deferred("add_child",new_animal)
