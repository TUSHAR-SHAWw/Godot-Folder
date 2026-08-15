class_name Ball
extends RigidBody2D

@onready var debug: Label = $Debug
const BallScene = preload("uid://bdr1x3qp6c6o")

var speed: int = 100
var direction: Vector2 = Vector2(1, -1)
var SpeedPowerTime: float = 10.0

var speed_time_left: float = 0.0
var speed_powerup_id: int = 0


func _ready() -> void:
	moveBall()


func moveBall() -> void:
	linear_velocity = direction * speed


func _physics_process(delta: float) -> void:
	# Keep ball moving at the current speed
	if linear_velocity.length() > 0:
		linear_velocity = linear_velocity.normalized() * speed

	# Speed powerup countdown
	if speed_time_left > 0:
		speed_time_left -= delta
		debug.text = "Speed: %.1f sec" % max(speed_time_left, 0.0)
	else:
		debug.text = "Speed: OFF"

	# Brick collision
	var colliders = get_colliding_bodies()

	for collider in colliders:
		if collider is Brick:
			Signalbus.emit_tile_hit(collider.position)
			collider.queue_free()


func SpeedPowerup() -> void:
	print("I am Speed")
	speed = 200
	speed_time_left = SpeedPowerTime
	# Give this powerup activation a unique ID
	speed_powerup_id += 1
	var current_id = speed_powerup_id
	# Start timer
	await get_tree().create_timer(SpeedPowerTime).timeout
	# Only the newest powerup is allowed to turn speed off
	if current_id == speed_powerup_id:
		speed = 100
		speed_time_left = 0

func On_powerup(name) -> void:
	if name=="speed":
		call_deferred("SpeedPowerup")
	if name=="split2":
		call_deferred("Split2Powerup")
		
func Split2Powerup() -> void:
	var newball:RigidBody2D=BallScene.instantiate()
	get_parent().add_child(newball)
	newball.global_position=global_position
		
	
