extends Area2D

signal collected(kind)

enum Kind { SHIELD, DOUBLE_SCORE, MAGNET }

@export var shield_texture: Texture2D = preload("res://assets/powerup_shield.svg")
@export var double_score_texture: Texture2D = preload("res://assets/powerup_double_score.svg")
@export var magnet_texture: Texture2D = preload("res://assets/powerup_magnet.svg")

var kind := Kind.SHIELD
var lifetime := 12.0
var _time := 0.0
var _collected := false
var _origin := Vector2.ZERO
@onready var visual: Sprite2D = $Sprite2D

func setup(new_kind: int, new_lifetime := 12.0) -> void:
	kind = clampi(new_kind, 0, 2)
	lifetime = new_lifetime
	_apply_visual()

func _ready() -> void:
	_origin = position
	collision_layer = 0
	collision_mask = 1
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(lifetime).timeout.connect(_expire)
	_apply_visual()

func _process(delta: float) -> void:
	_time += delta
	position = _origin + Vector2(0.0, sin(_time * 3.0) * 5.0)
	visual.rotation = sin(_time * 2.0) * 0.08

func _on_body_entered(body: Node) -> void:
	if _collected or not body.is_in_group("player"):
		return
	_collected = true
	set_deferred("monitoring", false)
	collected.emit(kind)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ONE * 1.8, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback(queue_free)

func _expire() -> void:
	if not _collected:
		queue_free()

func _apply_visual() -> void:
	if is_instance_valid(visual):
		match kind:
			Kind.DOUBLE_SCORE:
				visual.texture = double_score_texture
			Kind.MAGNET:
				visual.texture = magnet_texture
			_:
				visual.texture = shield_texture
