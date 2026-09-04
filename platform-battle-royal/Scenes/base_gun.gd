extends Node2D
var shooting:bool=false
var bullet_count=0
var shooted:bool=false
var spawn_rate=2 #per sec
const BULLET = preload("uid://cxghpsug3a7kp")
@onready var sprite: Sprite2D = $Sprite2D

func _unhandled_input(event: InputEvent) -> void:
	if shooted:
		shooting=false
		return
	if event.is_action_pressed("click"):
		shooting=true
	if event.is_action_released("click"):
		shooting=false

func _physics_process(delta: float) -> void:
	if shooting:
		shoot()
		
func shoot()->void:
	if shooted:
		return
	bullet_count+=1
	shooted=true
	print("bullet",bullet_count)
	var newbullet=BULLET.instantiate()
	get_tree().current_scene.get_node("Bullets").add_child(newbullet)
	newbullet.global_position=global_position+Vector2(global_position.x+5,global_position.y+5)
	await get_tree().create_timer(1/spawn_rate).timeout
	shooted=false

func flipx(dir):
	if dir==1:
		global_rotation=180
	elif dir==-1:
		global_rotation=0
	
func flipy(dir):
	if dir==1:
		global_rotation=90
	elif dir==-1:
		global_rotation=270
