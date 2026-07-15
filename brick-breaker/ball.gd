class_name Ball
extends RigidBody2D

var speed:int=100
var direction:Vector2=Vector2(1,-1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	moveBall()

func moveBall()->void:
	linear_velocity=direction*speed

func  _physics_process(delta: float) -> void:
	if linear_velocity.length() > 0:
		linear_velocity = linear_velocity.normalized() * speed
	var colliders=get_colliding_bodies()
	for collider in colliders:
		print (collider.name)
		if collider is Brick:
			collider.queue_free()
	


func _on_body_entered(body: Node) -> void:
	if body is Brick:
		body.queue_free()
