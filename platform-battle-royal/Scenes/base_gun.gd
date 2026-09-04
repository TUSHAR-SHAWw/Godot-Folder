extends Node2D
var shooting:bool=false
var bullet_count=0
var shooted:bool=false
var spawn_rate=2 #per sec
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
	await get_tree().create_timer(1/spawn_rate).timeout
	shooted=false
