extends CharacterBody2D
class_name  Ball
@export var Speed =30000
var directionx=0
var directiony=0
# Called when the node enters the scene tree for the first time.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		directionx= -1 if randi_range(0,1)==0 else 1
		directiony=-1 if randi_range(0,1)==0 else 1
func _ready() -> void:
	pass # Replace with function body.

func flipx():
	directionx = 1 if directionx == -1 else -1
func flipy():
	directiony = 1 if directiony == -1 else -1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.x=Speed*delta*directionx
	velocity.y=Speed*delta*directiony
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	#print(body.name)
	if body is Player or body is Player2:
		flipx()


func _on_detection_area_area_entered(area: Area2D) -> void:
	print(area.name)
	if area is border:
		flipy()
