extends CharacterBody2D
class_name  Ball
@export var Speed =500
var directionx:int=0
var directiony:float=0
# Called when the node enters the scene tree for the first time.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		directionx= -1 if randi_range(0,1)==0 else 1
		directiony=-1 if randi_range(0,1)==0 else 1
func _ready() -> void:
	pass # Replace with function body.

func flipx():
	directionx = 1 if directionx == -1 else -1
func flipydiff(body:CharacterBody2D):
	directiony = (body.position.y-position.y)/35
func flipy():
	if directiony >=0:
		directiony*=-1
	else:
		directiony= abs(directiony)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.x=Speed*directionx
	velocity.y=Speed*directiony
	var collide=move_and_collide(velocity*delta)
	if collide:
		var normal=collide.get_normal()
		print(normal)
		var obj=collide.get_collider()
		if abs(normal.x) < 0.1:
			flipy()
		elif obj is Player or obj is Player2:
			flipydiff(obj)
			flipx()
		global_position += normal* 2
		
