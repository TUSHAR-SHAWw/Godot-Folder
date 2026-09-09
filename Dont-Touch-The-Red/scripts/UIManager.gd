extends CanvasLayer

## All game UI built in code with responsive anchors/containers so it adapts to
## any aspect ratio (web, desktop, mobile). The HUD shows TIME / BEST during
## play; the menu and game-over panels are full-screen overlays.

signal play_pressed
signal try_again_pressed
signal menu_pressed

const OVERLAY_BG := Color(0.05, 0.05, 0.09, 0.82)
const ACCENT := Color("#e02323")

var hud: Control
var hud_timer: Label
var hud_best: Label
var menu_best: Label
var menu_panel: Control
var go_score: Label
var go_best: Label
var go_panel: Control

func _ready() -> void:
	_build_hud()
	_build_menu()
	_build_game_over()

# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

func show_menu(best: int) -> void:
	hud.visible = false
	go_panel.visible = false
	menu_panel.visible = true
	menu_best.text = "BEST: %d" % best

func show_hud(best: int) -> void:
	menu_panel.visible = false
	go_panel.visible = false
	hud.visible = true
	update_timer(0.0)
	hud_best.text = "BEST: " + _fmt_time(best)

func show_game_over(score: int, best: int) -> void:
	hud.visible = false
	menu_panel.visible = false
	go_panel.visible = true
	go_score.text = "SCORE: %d" % score
	go_best.text = "BEST: %d" % best

func update_timer(seconds: float) -> void:
	hud_timer.text = "TIME: " + _fmt_time(int(seconds))

# ---------------------------------------------------------------------------
# Construction
# ---------------------------------------------------------------------------

func _build_hud() -> void:
	hud = Control.new()
	hud.set_anchors_preset(Control.PRESET_FULL_RECT)
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(hud)

	var bar := ColorRect.new()
	bar.color = Color(0.07, 0.07, 0.10, 0.82)
	bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	bar.offset_bottom = 92.0
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(bar)

	hud_timer = _label("TIME: 00:00", 52, Color.WHITE)
	hud_timer.anchor_left = 0.5
	hud_timer.anchor_right = 0.5
	hud_timer.offset_left = -220.0
	hud_timer.offset_right = 220.0
	hud_timer.offset_top = 18.0
	hud_timer.offset_bottom = 74.0
	hud_timer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hud_timer.grow_horizontal = Control.GROW_DIRECTION_BOTH
	hud.add_child(hud_timer)

	hud_best = _label("BEST: 00:00", 30, Color("#c5c5cf"))
	hud_best.anchor_left = 1.0
	hud_best.anchor_right = 1.0
	hud_best.offset_left = -260.0
	hud_best.offset_right = -24.0
	hud_best.offset_top = 28.0
	hud_best.offset_bottom = 66.0
	hud_best.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hud_best.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	hud.add_child(hud_best)

func _build_menu() -> void:
	menu_panel = _make_panel()
	add_child(menu_panel)

	var center := _make_centered_box()
	menu_panel.add_child(center)
	var box: VBoxContainer = center.get_child(0)

	var title := _label("DON'T TOUCH THE RED", 60, Color.WHITE)
	box.add_child(title)
	var sub := _label("WHITE = SAFE   •   RED = DEATH", 26, Color("#b8b8c4"))
	box.add_child(sub)

	var play := _button("PLAY", ACCENT)
	play.pressed.connect(func() -> void: play_pressed.emit())
	box.add_child(play)

	menu_best = _label("BEST: 0", 30, Color("#e8e8ef"))
	box.add_child(menu_best)

func _build_game_over() -> void:
	go_panel = _make_panel()
	add_child(go_panel)

	var center := _make_centered_box()
	go_panel.add_child(center)
	var box: VBoxContainer = center.get_child(0)

	var title := _label("GAME OVER", 62, Color("#ff5b5b"))
	box.add_child(title)
	go_score = _label("SCORE: 0", 42, Color.WHITE)
	box.add_child(go_score)
	go_best = _label("BEST: 0", 30, Color("#cfcfd8"))
	box.add_child(go_best)

	var try_again := _button("TRY AGAIN", ACCENT)
	try_again.pressed.connect(func() -> void: try_again_pressed.emit())
	box.add_child(try_again)
	var menu := _button("MENU", Color("#3a3a44"))
	menu.pressed.connect(func() -> void: menu_pressed.emit())
	box.add_child(menu)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

func _make_panel() -> Control:
	var p := Control.new()
	p.set_anchors_preset(Control.PRESET_FULL_RECT)
	p.visible = false
	var overlay := ColorRect.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.color = OVERLAY_BG
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	p.add_child(overlay)
	return p

func _make_centered_box() -> CenterContainer:
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 22)
	center.add_child(box)
	return center

func _label(text: String, size: int, color: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l

func _button(text: String, bg: Color) -> Button:
	var b := Button.new()
	b.text = text
	b.add_theme_font_size_override("font_size", 32)
	b.custom_minimum_size = Vector2(320, 70)

	var normal := StyleBoxFlat.new()
	normal.bg_color = bg
	normal.set_corner_radius_all(14)
	normal.content_margin_left = 24.0
	normal.content_margin_right = 24.0
	b.add_theme_stylebox_override("normal", normal)

	var hover := normal.duplicate()
	hover.bg_color = bg.lightened(0.12)
	b.add_theme_stylebox_override("hover", hover)

	var pressed := normal.duplicate()
	pressed.bg_color = bg.darkened(0.18)
	b.add_theme_stylebox_override("pressed", pressed)
	return b

func _fmt_time(v: int) -> String:
	var m := v / 60
	var s := v % 60
	return "%02d:%02d" % [m, s]
