extends AnimatableBody2D


@onready var animation_player = $AnimationPlayer

func _ready():
	await get_tree().create_timer(1.5).timeout  # Delay for 2 seconds
	animation_player.play("moving")  # Play animation after delay
