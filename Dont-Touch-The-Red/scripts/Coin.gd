extends Area2D

signal collected(value)
signal removed(coin)

enum Kind { COMMON, RARE, EPIC }

@export var common_texture: Texture2D = preload("res://assets/coin_common.svg")
@export var rare_texture: Texture2D = preload("res://assets/coin_rare.svg")
@export var epic_texture: Texture2D = preload("res://assets/coin_epic.svg")

var value := 1
var kind := Kind.COMMON
var lifetime := 10.0
var _time := 0.0
var _collected := false
var _origin := Vector2.ZERO
var _main: Node = null
@onready var visual: Sprite2D = $Sprite2D

func setup(new_kind: int, common_lifetime := 9.0, rare_lifetime := 12.0, epic_lifetime := 15.0) -> void:
	kind = clampi(new_kind, 0, 2)
	match kind:
		Kind.RARE:
			value = 3
			lifetime = rare_lifetime
		Kind.EPIC:
			value = 8
			lifetime = epic_lifetime
		_:
			value = 1
			lifetime = common_lifetime
	_apply_visual()

func _ready() -> void:
	_origin = position
	_main = get_tree().current_scene
	collision_layer = 0
	collision_mask = 1
	monitoring = true
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(lifetime).timeout.connect(_expire)
	_apply_visual()

func _process(delta: float) -> void:
	_time += delta
	if _main and _main.has_method("is_magnet_active") and _main.is_magnet_active():
		var target = _main.get_node("Player").global_position
		global_position = global_position.move_toward(target, 240.0 * delta)
	else:
		position.y = _origin.y + sin(_time * 3.0) * 4.0
	visual.rotation = sin(_time * 2.5) * 0.12

func _expire() -> void:
	if not _collected:
		removed.emit(self)
		queue_free()

func _on_body_entered(body: Node) -> void:
	if _collected or not body.is_in_group("player"):
		return
	_collected = true
	set_deferred("monitoring", false)
	removed.emit(self)
	collected.emit(value)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ONE * 1.65, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.18)
	tween.chain().tween_callback(queue_free)

func _apply_visual() -> void:
	if is_instance_valid(visual):
		match kind:
			Kind.RARE:
				visual.texture = rare_texture
			Kind.EPIC:
				visual.texture = epic_texture
			_:
				visual.texture = common_texture
