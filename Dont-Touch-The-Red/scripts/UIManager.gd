extends CanvasLayer

## All game UI built in code with responsive anchors/containers so it adapts to
## any aspect ratio (web, desktop, mobile). The HUD shows TIME / BEST during
## play; the menu and game-over panels are full-screen overlays.

signal play_pressed
signal try_again_pressed
signal menu_pressed
signal mode_selected(mode)
signal skin_selected(skin)
signal skin_menu_pressed
signal skin_menu_closed
signal multiplier_upgrade_pressed
signal control_mode_selected(enabled)
signal touch_vector_changed(value)
signal settings_menu_pressed
signal settings_menu_closed
signal setting_changed(name, value)
signal reset_game_requested
signal quit_requested
signal pause_requested
signal resume_requested
signal pause_settings_requested
signal pause_menu_requested
signal shop_menu_pressed
signal shop_menu_closed
signal shop_action(item, action)
signal item_use_requested(item)

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
var skin_panel: Control
var settings_panel: Control
var shop_panel: Control
var _loading_panel: Control
var _loading_label: Label
var _loading_bar: ColorRect
var _menu_title: Label
var pause_panel: Control
var _flash: ColorRect
var _milestone: Label
var _powerup_label: Label
var _coins_label: Label
var _menu_coins_label: Label
var _score_label: Label
var _multiplier_label: Label
var _effects_panel: VBoxContainer
var _effect_labels: Dictionary = {}
var _upgrade_button: Button
var _upgrade_label: Label
var _skin_buttons: Array[Button] = []
var _skin_costs: Array = []
var _menu_center: CenterContainer
var _skin_center: CenterContainer
var _go_center: CenterContainer
var _settings_center: CenterContainer
var _shop_center: CenterContainer
var _pause_center: CenterContainer
var _shop_buttons: Array[Button] = []
var _item_buttons: Array[Button] = []
var _touch_joystick: Control
var _touch_button: Button
var _setting_buttons: Dictionary = {}
var _reduced_effects := false
var _touch_controls := false
var _skin_colors := [
	Color("#23232b"), Color("#147d92"), Color("#6d3bb5"), Color("#c27b16"), Color("#b83232"),
	Color("#2e8b57"), Color("#2374ab"), Color("#9b3d9b"), Color("#d05b2d"), Color("#4b5563"),
	Color("#0f766e"), Color("#be185d"), Color("#4d7c0f"), Color("#7c3aed"), Color("#b45309"),
	Color("#334155"), Color("#0891b2"), Color("#dc2626"), Color("#65a30d"), Color("#f59e0b")
]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_hud()
	_build_menu()
	_build_game_over()
	_build_skin_menu()
	_build_settings_menu()
	_build_shop_menu()
	_build_loading_screen()
	_build_pause_menu()
	_skin_costs = []
	for i in range(20):
		_skin_costs.append(0 if i == 0 else 15 + i * 10)
	_flash = ColorRect.new()
	_flash.color = Color(0.9, 0.05, 0.05, 0.0)
	_flash.set_anchors_preset(Control.PRESET_FULL_RECT)
	_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_flash)
	_milestone = _label("10 SECONDS", 34, Color("#e02323"))
	_milestone.set_anchors_preset(Control.PRESET_CENTER)
	_milestone.position = Vector2(-220.0, -24.0)
	_milestone.size = Vector2(440.0, 48.0)
	_milestone.modulate.a = 0.0
	_milestone.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_milestone)
	_powerup_label = _label("POWERUP", 28, Color("#ffcc58"))
	_powerup_label.set_anchors_preset(Control.PRESET_CENTER)
	_powerup_label.position = Vector2(-260.0, 24.0)
	_powerup_label.size = Vector2(520.0, 42.0)
	_powerup_label.modulate.a = 0.0
	_powerup_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_powerup_label)
	_build_touch_joystick()
	_apply_responsive_layout()
	get_viewport().size_changed.connect(_apply_responsive_layout)
	_animate_menu_accent()

func set_touch_controls(enabled: bool) -> void:
	_touch_controls = enabled
	if is_instance_valid(_touch_joystick):
		_touch_joystick.visible = enabled and hud.visible
	if is_instance_valid(_touch_button):
		_touch_button.text = "TOUCH JOYSTICK: ON" if enabled else "TOUCH JOYSTICK: OFF"
	if _setting_buttons.has("touch_controls"):
		_setting_buttons["touch_controls"].text = "TOUCH JOYSTICK: ON" if enabled else "TOUCH JOYSTICK: OFF"

func set_settings(music_enabled: bool, sfx_enabled: bool, shake_enabled: bool, reduced_effects: bool, touch_enabled: bool) -> void:
	_set_setting_button("music", music_enabled, "MUSIC")
	_set_setting_button("sfx", sfx_enabled, "SFX")
	_set_setting_button("shake", shake_enabled, "SCREEN SHAKE")
	_set_setting_button("reduced_effects", reduced_effects, "REDUCED EFFECTS")
	_set_setting_button("touch_controls", touch_enabled, "TOUCH JOYSTICK")

func _set_setting_button(key: String, enabled: bool, label: String) -> void:
	if not _setting_buttons.has(key):
		return
	_setting_buttons[key].text = "%s: %s" % [label, "ON" if enabled else "OFF"]
	_setting_buttons[key].modulate = Color.WHITE if enabled else Color(0.65, 0.65, 0.7)

func set_reduced_effects(enabled: bool) -> void:
	_reduced_effects = enabled

func set_progression(total_coins: int, selected_skin: int, unlocked: Array, multiplier_level := 0) -> void:
	if _coins_label:
		_coins_label.text = "COINS: %d" % total_coins
	if _menu_coins_label:
		_menu_coins_label.text = "COINS: %d" % total_coins
	if _upgrade_label:
		_upgrade_label.text = "PERMANENT MULTIPLIER: x%.1f" % minf(5.0, 1.0 + multiplier_level * 0.5)
	if _upgrade_button:
		if multiplier_level >= 8:
			_upgrade_button.text = "MULTIPLIER MAXED"
			_upgrade_button.disabled = true
		else:
			_upgrade_button.text = "UPGRADE MULTIPLIER - %d COINS" % (50 + multiplier_level * 75)
			_upgrade_button.disabled = false
	for i in range(_skin_buttons.size()):
		var available = i < unlocked.size() and unlocked[i]
		_skin_buttons[i].text = "EQUIPPED" if available and i == selected_skin else ("SKIN %02d" % (i + 1) if available else "%d COINS" % _skin_costs[i])
		_skin_buttons[i].modulate = Color.WHITE if i == selected_skin else Color(0.65, 0.65, 0.7)

func set_shop(total_coins: int, inventory: Array) -> void:
	for i in range(_shop_buttons.size()):
		var count := int(inventory[i]) if i < inventory.size() else 0
		var price: int = [30, 60, 90][i]
		_shop_buttons[i].text = "BUY  %d COINS  [%d IN STOCK]" % [price, count]
		_shop_buttons[i].modulate = Color.WHITE if count == 0 else Color(0.8, 0.8, 0.85)

func set_item_inventory(inventory: Array) -> void:
	var labels := ["1 SHIELD", "2 DOUBLE", "3 MAGNET"]
	for i in range(_item_buttons.size()):
		var count := int(inventory[i]) if i < inventory.size() else 0
		_item_buttons[i].text = "%s  x%d" % [labels[i], count]
		_item_buttons[i].disabled = count <= 0

func flash_danger() -> void:
	if _reduced_effects:
		return
	_flash.color.a = 0.42
	var tween := create_tween()
	tween.tween_property(_flash, "color:a", 0.0, 0.3)

func pulse_danger() -> void:
	if not hud.visible:
		return
	var tween := create_tween()
	tween.tween_property(hud_timer, "scale", Vector2(1.08, 1.08), 0.06)
	tween.tween_property(hud_timer, "scale", Vector2.ONE, 0.16)

func show_milestone(seconds: int) -> void:
	_milestone.text = "%d SECONDS" % seconds
	_milestone.modulate = Color(1.0, 0.2, 0.2, 0.0)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(_milestone, "modulate:a", 1.0, 0.12)
	tween.tween_property(_milestone, "scale", Vector2(1.12, 1.12), 0.12)
	tween.chain().tween_property(_milestone, "modulate:a", 0.0, 0.7)
	tween.parallel().tween_property(_milestone, "scale", Vector2.ONE, 0.7)

func show_powerup(text: String) -> void:
	_powerup_label.text = text
	_powerup_label.modulate = Color(1.0, 0.8, 0.3, 0.0)
	var tween := create_tween()
	tween.tween_property(_powerup_label, "modulate:a", 1.0, 0.1)
	tween.tween_interval(1.0)
	tween.tween_property(_powerup_label, "modulate:a", 0.0, 0.35)

func show_pickup(text: String, color: Color) -> void:
	var popup := _label(text, 28, color)
	popup.set_anchors_preset(Control.PRESET_CENTER)
	popup.position = Vector2(-90.0, -58.0)
	popup.size = Vector2(180.0, 44.0)
	popup.modulate.a = 0.0
	popup.scale = Vector2(0.7, 0.7)
	popup.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(popup)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(popup, "modulate:a", 1.0, 0.08)
	tween.tween_property(popup, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(popup, "position:y", -112.0, 0.65).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(popup, "modulate:a", 0.0, 0.25)
	tween.chain().tween_callback(popup.queue_free)

# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

func show_menu(best: int) -> void:
	hud.visible = false
	go_panel.visible = false
	skin_panel.visible = false
	settings_panel.visible = false
	shop_panel.visible = false
	pause_panel.visible = false
	menu_panel.visible = true
	_touch_joystick.visible = false
	menu_best.text = "BEST: " + _fmt_time(best)
	_animate_center(_menu_center)
	_loading_panel.visible = false
	_animate_menu_accent()

func show_loading(text := "LOADING") -> void:
	_loading_panel.visible = true
	_loading_label.text = text
	_loading_bar.size.x = 0.0
	var tween := create_tween()
	tween.tween_property(_loading_bar, "size:x", 420.0, 0.35)

func hide_loading() -> void:
	_loading_panel.visible = false

func show_skin_menu() -> void:
	hud.visible = false
	menu_panel.visible = false
	go_panel.visible = false
	settings_panel.visible = false
	shop_panel.visible = false
	pause_panel.visible = false
	skin_panel.visible = true
	_touch_joystick.visible = false
	_animate_center(_skin_center)

func show_settings() -> void:
	hud.visible = false
	menu_panel.visible = false
	go_panel.visible = false
	skin_panel.visible = false
	shop_panel.visible = false
	pause_panel.visible = false
	settings_panel.visible = true
	_touch_joystick.visible = false

func show_shop() -> void:
	hud.visible = false
	menu_panel.visible = false
	go_panel.visible = false
	skin_panel.visible = false
	settings_panel.visible = false
	pause_panel.visible = false
	shop_panel.visible = true
	_animate_center(_shop_center)

func show_pause() -> void:
	hud.visible = true
	pause_panel.visible = true
	_touch_joystick.visible = false
	_animate_center(_pause_center)

func hide_pause() -> void:
	pause_panel.visible = false

func show_hud(best: int, total_coins := 0, multiplier := 1.0) -> void:
	hide_loading()
	menu_panel.visible = false
	go_panel.visible = false
	skin_panel.visible = false
	settings_panel.visible = false
	shop_panel.visible = false
	pause_panel.visible = false
	hud.visible = true
	_touch_joystick.visible = _touch_controls
	update_timer(0.0, 0, multiplier, total_coins)
	hud_best.text = "BEST: " + _fmt_time(best)

func show_game_over(score: int, best: int, earned_coins := 0, multiplier := 1.0) -> void:
	hud.visible = false
	menu_panel.visible = false
	skin_panel.visible = false
	settings_panel.visible = false
	shop_panel.visible = false
	pause_panel.visible = false
	go_panel.visible = true
	_touch_joystick.visible = false
	go_score.text = "SCORE: %d" % score
	go_best.text = "BEST: " + _fmt_time(best) + "   +%d COINS   x%.1f" % [earned_coins, multiplier]
	_animate_center(_go_center)

func update_timer(seconds: float, score := 0, multiplier := 1.0, total_coins := 0) -> void:
	hud_timer.text = "TIME: " + _fmt_time(int(seconds))
	_score_label.text = "SCORE: %d" % score
	_multiplier_label.text = "x%.1f" % multiplier
	_coins_label.text = "COINS: %d" % total_coins

func update_active_effects(shield: bool, score_time: float, magnet_time: float) -> void:
	_effect_labels["shield"].visible = shield
	_effect_labels["shield"].text = "SHIELD       READY"
	_effect_labels["shield"].add_theme_color_override("font_color", Color("#72d99a"))
	_effect_labels["score"].visible = score_time > 0.0
	_effect_labels["score"].text = "DOUBLE SCORE  %02ds" % ceili(score_time)
	_effect_labels["score"].add_theme_color_override("font_color", Color("#ffcc58"))
	_effect_labels["magnet"].visible = magnet_time > 0.0
	_effect_labels["magnet"].text = "COIN MAGNET   %02ds" % ceili(magnet_time)
	_effect_labels["magnet"].add_theme_color_override("font_color", Color("#70c8ff"))

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
	var bar_accent := ColorRect.new()
	bar_accent.color = Color("#f59e0b")
	bar_accent.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	bar_accent.offset_top = -4.0
	bar_accent.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.add_child(bar_accent)

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

	_score_label = _label("SCORE: 0", 24, Color("#e8e8ef"))
	_score_label.position = Vector2(24.0, 28.0)
	hud.add_child(_score_label)
	_multiplier_label = _label("x1.0", 30, Color("#ffcc58"))
	_multiplier_label.position = Vector2(24.0, 54.0)
	hud.add_child(_multiplier_label)
	_coins_label = _label("COINS: 0", 24, Color("#f0c35c"))
	_coins_label.anchor_left = 1.0
	_coins_label.anchor_right = 1.0
	_coins_label.offset_left = -220.0
	_coins_label.offset_right = -24.0
	_coins_label.offset_top = 62.0
	_coins_label.offset_bottom = 90.0
	_coins_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hud.add_child(_coins_label)

	var effects_background := ColorRect.new()
	effects_background.color = Color(0.05, 0.05, 0.09, 0.78)
	effects_background.anchor_left = 1.0
	effects_background.anchor_right = 1.0
	effects_background.offset_left = -290.0
	effects_background.offset_right = -18.0
	effects_background.offset_top = 102.0
	effects_background.offset_bottom = 224.0
	effects_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud.add_child(effects_background)
	_effects_panel = VBoxContainer.new()
	_effects_panel.position = Vector2(12.0, 8.0)
	_effects_panel.size = Vector2(248.0, 106.0)
	effects_background.add_child(_effects_panel)
	var effects_title := _label("ACTIVE POWERUPS", 16, Color("#b8b8c4"))
	effects_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_effects_panel.add_child(effects_title)
	for key in ["shield", "score", "magnet"]:
		var effect_label := _label("", 19, Color.WHITE)
		effect_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		effect_label.visible = false
		_effect_labels[key] = effect_label
		_effects_panel.add_child(effect_label)

	var item_bar := HBoxContainer.new()
	item_bar.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	item_bar.position = Vector2(-270.0, -76.0)
	item_bar.size = Vector2(540.0, 58.0)
	item_bar.alignment = BoxContainer.ALIGNMENT_CENTER
	item_bar.add_theme_constant_override("separation", 8)
	for i in range(3):
		var item_button := _button("ITEM", Color("#3a3a44"))
		item_button.custom_minimum_size = Vector2(170, 52)
		item_button.add_theme_font_size_override("font_size", 16)
		var item_index := i
		item_button.pressed.connect(func() -> void: item_use_requested.emit(item_index))
		item_bar.add_child(item_button)
		_item_buttons.append(item_button)
	hud.add_child(item_bar)
	var pause_button := _button("PAUSE", Color("#3a3a44"))
	pause_button.set_anchors_preset(Control.PRESET_TOP_LEFT)
	pause_button.position = Vector2(24.0, 104.0)
	pause_button.custom_minimum_size = Vector2(132, 48)
	pause_button.add_theme_font_size_override("font_size", 18)
	pause_button.pressed.connect(func() -> void: pause_requested.emit())
	hud.add_child(pause_button)

func _build_menu() -> void:
	menu_panel = _make_panel()
	add_child(menu_panel)

	var center := _make_centered_box()
	_menu_center = center
	menu_panel.add_child(center)
	var box: VBoxContainer = center.get_child(0)
	box.add_theme_constant_override("separation", 14)

	_menu_title = _label("DON'T TOUCH THE RED", 60, Color.WHITE)
	box.add_child(_menu_title)
	var sub := _label("DODGE THE RED   •   CHASE THE SCORE", 26, Color("#f7c85b"))
	box.add_child(sub)

	var play := _button("PLAY", ACCENT)
	play.pressed.connect(func() -> void: play_pressed.emit())
	box.add_child(play)
	var modes := HBoxContainer.new()
	modes.alignment = BoxContainer.ALIGNMENT_CENTER
	modes.add_theme_constant_override("separation", 10)
	for mode in ["CLASSIC\nBALANCED", "RUSH\nHIGH SCORE", "ZEN\nBREATHING ROOM"]:
		var index := modes.get_child_count()
		var mode_button := _button(mode, Color("#3a3a44"))
		mode_button.custom_minimum_size = Vector2(140, 52)
		mode_button.add_theme_font_size_override("font_size", 20)
		mode_button.pressed.connect(func() -> void: mode_selected.emit(index))
		modes.add_child(mode_button)
	box.add_child(modes)

	var nav := HBoxContainer.new()
	nav.alignment = BoxContainer.ALIGNMENT_CENTER
	nav.add_theme_constant_override("separation", 8)
	_add_menu_nav_button(nav, "SKINS", func() -> void: skin_menu_pressed.emit())
	_add_menu_nav_button(nav, "SHOP", func() -> void: shop_menu_pressed.emit())
	_add_menu_nav_button(nav, "SETTINGS", func() -> void: settings_menu_pressed.emit())
	box.add_child(nav)
	_menu_coins_label = _label("COINS: 0", 24, Color("#f0c35c"))
	box.add_child(_menu_coins_label)
	var quit_button := _button("QUIT", Color("#6d2020"))
	quit_button.custom_minimum_size = Vector2(250, 42)
	quit_button.add_theme_font_size_override("font_size", 16)
	quit_button.pressed.connect(func() -> void: quit_requested.emit())
	box.add_child(quit_button)

	menu_best = _label("BEST: 0", 30, Color("#e8e8ef"))
	box.add_child(menu_best)

func _add_menu_nav_button(parent: HBoxContainer, text: String, action: Callable) -> void:
	var button := _button(text, Color("#3a3a44"))
	button.custom_minimum_size = Vector2(116, 46)
	button.add_theme_font_size_override("font_size", 16)
	button.pressed.connect(action)
	parent.add_child(button)

func _build_settings_menu() -> void:
	settings_panel = _make_panel()
	add_child(settings_panel)
	var center := _make_centered_box()
	_settings_center = center
	settings_panel.add_child(center)
	var box: VBoxContainer = center.get_child(0)
	var title := _label("SETTINGS", 52, Color.WHITE)
	box.add_child(title)
	var subtitle := _label("TUNE THE EXPERIENCE", 20, Color("#b8b8c4"))
	box.add_child(subtitle)
	_add_setting_button(box, "music", "MUSIC")
	_add_setting_button(box, "sfx", "SFX")
	_add_setting_button(box, "shake", "SCREEN SHAKE")
	_add_setting_button(box, "reduced_effects", "REDUCED EFFECTS")
	_add_setting_button(box, "touch_controls", "TOUCH JOYSTICK")
	var reset := _button("RESET GAME DATA", Color("#6d2020"))
	reset.custom_minimum_size = Vector2(320, 58)
	reset.add_theme_font_size_override("font_size", 18)
	reset.pressed.connect(func() -> void: reset_game_requested.emit())
	box.add_child(reset)
	var back := _button("BACK", Color("#3a3a44"))
	back.custom_minimum_size = Vector2(320, 58)
	back.pressed.connect(func() -> void: settings_menu_closed.emit())
	box.add_child(back)

func _build_shop_menu() -> void:
	shop_panel = _make_panel()
	add_child(shop_panel)
	var center := _make_centered_box()
	_shop_center = center
	shop_panel.add_child(center)
	var box: VBoxContainer = center.get_child(0)
	box.add_child(_label("ITEM SHOP", 52, Color.WHITE))
	box.add_child(_label("BUY ITEMS WITH COINS. EQUIP ONE FOR YOUR NEXT RUN.", 18, Color("#b8b8c4")))
	_add_shop_item(box, 0, "SHIELD PACK", "START WITH ONE FREE HIT", Color("#72d99a"))
	_add_shop_item(box, 1, "DOUBLE SCORE PACK", "DOUBLE SCORE FOR 8 SECONDS", Color("#ffcc58"))
	_add_shop_item(box, 2, "COIN MAGNET PACK", "PULL COINS FOR 8 SECONDS", Color("#70c8ff"))
	_upgrade_label = _label("PERMANENT MULTIPLIER: x1.0", 20, Color("#ffcc58"))
	box.add_child(_upgrade_label)
	_upgrade_button = _button("UPGRADE MULTIPLIER - 50 COINS", Color("#8b5a12"))
	_upgrade_button.custom_minimum_size = Vector2(420, 50)
	_upgrade_button.add_theme_font_size_override("font_size", 17)
	_upgrade_button.pressed.connect(func() -> void: multiplier_upgrade_pressed.emit())
	box.add_child(_upgrade_button)
	var back := _button("BACK", Color("#3a3a44"))
	back.custom_minimum_size = Vector2(320, 56)
	back.pressed.connect(func() -> void: shop_menu_closed.emit())
	box.add_child(back)

func _add_shop_item(box: VBoxContainer, item: int, title: String, description: String, color: Color) -> void:
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 12)
	var label := _label(title + "\n" + description, 18, color)
	label.custom_minimum_size = Vector2(300, 58)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	row.add_child(label)
	var button := _button("BUY", color.darkened(0.35))
	button.custom_minimum_size = Vector2(210, 58)
	button.add_theme_font_size_override("font_size", 17)
	var item_index := item
	button.pressed.connect(func() -> void: shop_action.emit(item_index, "buy" if button.text.begins_with("BUY") else "equip"))
	row.add_child(button)
	_shop_buttons.append(button)
	box.add_child(row)

func _add_setting_button(box: VBoxContainer, key: String, label: String) -> void:
	var button := _button(label + ": OFF", Color("#3a3a44"))
	button.custom_minimum_size = Vector2(320, 58)
	button.add_theme_font_size_override("font_size", 20)
	button.pressed.connect(func() -> void: setting_changed.emit(key, not _setting_is_on(key)))
	_setting_buttons[key] = button
	box.add_child(button)

func _setting_is_on(key: String) -> bool:
	return _setting_buttons[key].modulate == Color.WHITE

func _build_skin_menu() -> void:
	skin_panel = _make_panel()
	add_child(skin_panel)
	var center := _make_centered_box()
	_skin_center = center
	skin_panel.add_child(center)
	var box: VBoxContainer = center.get_child(0)
	var title := _label("SKIN COLLECTION", 48, Color.WHITE)
	box.add_child(title)
	var subtitle := _label("UNLOCK NEW COLORS AS YOU SURVIVE", 18, Color("#b8b8c4"))
	box.add_child(subtitle)
	var grid := GridContainer.new()
	grid.columns = 5
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	for i in range(20):
		var skin_button := _button("SKIN %02d" % (i + 1), _skin_colors[i])
		skin_button.custom_minimum_size = Vector2(142, 58)
		skin_button.add_theme_font_size_override("font_size", 16)
		var skin_index := i
		skin_button.pressed.connect(func() -> void: skin_selected.emit(skin_index))
		grid.add_child(skin_button)
		_skin_buttons.append(skin_button)
	box.add_child(grid)
	var back := _button("BACK", Color("#3a3a44"))
	back.custom_minimum_size = Vector2(320, 52)
	back.pressed.connect(func() -> void: skin_menu_closed.emit())
	box.add_child(back)

func _build_game_over() -> void:
	go_panel = _make_panel()
	add_child(go_panel)

	var center := _make_centered_box()
	_go_center = center
	go_panel.add_child(center)
	var box: VBoxContainer = center.get_child(0)

	var title := _label("GAME OVER", 62, Color("#ff5b5b"))
	box.add_child(title)
	var finish := _label("THE ARENA WINS THIS ROUND", 22, Color("#f7c85b"))
	box.add_child(finish)
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

func _build_loading_screen() -> void:
	_loading_panel = Control.new()
	_loading_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	_loading_panel.visible = false
	_loading_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	var backdrop := ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color("#11131d")
	_loading_panel.add_child(backdrop)
	_loading_label = _label("LOADING RUN", 34, Color.WHITE)
	_loading_label.set_anchors_preset(Control.PRESET_CENTER)
	_loading_label.position = Vector2(-220.0, -30.0)
	_loading_label.size = Vector2(440.0, 48.0)
	_loading_panel.add_child(_loading_label)
	var track := ColorRect.new()
	track.set_anchors_preset(Control.PRESET_CENTER)
	track.position = Vector2(-210.0, 34.0)
	track.size = Vector2(420.0, 6.0)
	track.color = Color("#303443")
	_loading_panel.add_child(track)
	_loading_bar = ColorRect.new()
	_loading_bar.position = Vector2(0.0, 0.0)
	_loading_bar.size = Vector2.ZERO
	_loading_bar.color = Color("#f59e0b")
	track.add_child(_loading_bar)
	add_child(_loading_panel)

func _animate_menu_accent() -> void:
	if not is_instance_valid(_menu_title):
		return
	_menu_title.modulate = Color.WHITE
	var tween := create_tween().set_loops()
	tween.tween_property(_menu_title, "modulate", Color("#ffd166"), 1.1)
	tween.tween_property(_menu_title, "modulate", Color.WHITE, 1.1)

func _build_pause_menu() -> void:
	pause_panel = _make_panel()
	add_child(pause_panel)
	var center := _make_centered_box()
	_pause_center = center
	pause_panel.add_child(center)
	var box: VBoxContainer = center.get_child(0)
	box.add_child(_label("PAUSED", 58, Color.WHITE))
	var resume := _button("RESUME", ACCENT)
	resume.pressed.connect(func() -> void: resume_requested.emit())
	box.add_child(resume)
	var settings := _button("SETTINGS", Color("#3a3a44"))
	settings.pressed.connect(func() -> void: pause_settings_requested.emit())
	box.add_child(settings)
	var menu := _button("QUIT TO MENU", Color("#6d2020"))
	menu.pressed.connect(func() -> void: pause_menu_requested.emit())
	box.add_child(menu)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

func _make_panel() -> Control:
	var p := Control.new()
	p.set_anchors_preset(Control.PRESET_FULL_RECT)
	p.visible = false
	var backdrop := _Backdrop.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(backdrop)
	var overlay := ColorRect.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.color = OVERLAY_BG
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	p.add_child(overlay)
	return p

func _animate_center(center: CenterContainer) -> void:
	if not is_instance_valid(center):
		return
	var target_scale := center.scale
	center.scale = target_scale * 0.94
	center.modulate.a = 0.0
	var tween := create_tween().set_parallel(true)
	tween.tween_property(center, "scale", target_scale, 0.24).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(center, "modulate:a", 1.0, 0.18)

func _make_centered_box() -> CenterContainer:
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 22)
	center.add_child(box)
	return center

func _apply_responsive_layout() -> void:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
		return
	var scale_factor := clampf(minf(viewport_size.x / 900.0, viewport_size.y / 620.0), 0.5, 1.0)
	for center in [_menu_center, _skin_center, _go_center, _settings_center, _shop_center, _pause_center]:
		if is_instance_valid(center):
			center.pivot_offset = viewport_size * 0.5
			center.scale = Vector2.ONE * scale_factor

func _build_touch_joystick() -> void:
	_touch_joystick = _TouchJoystick.new()
	_touch_joystick.name = "TouchJoystick"
	_touch_joystick.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	_touch_joystick.position = Vector2(28.0, -208.0)
	_touch_joystick.size = Vector2(180.0, 180.0)
	_touch_joystick.mouse_filter = Control.MOUSE_FILTER_STOP
	_touch_joystick.vector_changed.connect(func(value: Vector2) -> void: touch_vector_changed.emit(value))
	add_child(_touch_joystick)

class _TouchJoystick extends Control:
	signal vector_changed(value: Vector2)
	var _touch_id := -1
	var _vector := Vector2.ZERO

	func _ready() -> void:
		queue_redraw()

	func _gui_input(event: InputEvent) -> void:
		if event is InputEventScreenTouch:
			if event.pressed and _touch_id == -1:
				_touch_id = event.index
				_update_vector(event.position)
			elif not event.pressed and event.index == _touch_id:
				_touch_id = -1
				_vector = Vector2.ZERO
				vector_changed.emit(_vector)
				queue_redraw()
		elif event is InputEventScreenDrag and event.index == _touch_id:
			_update_vector(event.position)

	func _update_vector(local_position: Vector2) -> void:
		var offset := local_position - size * 0.5
		_vector = offset.limit_length(size.x * 0.38) / (size.x * 0.38)
		vector_changed.emit(_vector)
		queue_redraw()

	func _draw() -> void:
		var center := size * 0.5
		draw_circle(center, 78.0, Color(0.05, 0.05, 0.09, 0.45))
		draw_arc(center, 78.0, 0.0, TAU, 32, Color(1.0, 1.0, 1.0, 0.35), 3.0)
		draw_circle(center + _vector * 42.0, 30.0, Color(0.88, 0.14, 0.14, 0.85))

class _Backdrop extends Control:
	func _ready() -> void:
		queue_redraw()

	func _draw() -> void:
		var area := size
		draw_rect(Rect2(Vector2.ZERO, area), Color("#07111f"))
		for i in range(-2, 12):
			var x := float(i) * 150.0
			draw_line(Vector2(x, area.y), Vector2(x + area.y * 0.55, 0.0), Color(0.15, 0.30, 0.46, 0.12), 2.0)
		draw_circle(Vector2(area.x * 0.14, area.y * 0.20), 110.0, Color(0.96, 0.62, 0.10, 0.08))
		draw_circle(Vector2(area.x * 0.88, area.y * 0.78), 180.0, Color(0.87, 0.08, 0.20, 0.08))
		draw_circle(Vector2(area.x * 0.50, area.y * 0.48), 210.0, Color(0.08, 0.38, 0.52, 0.05))
		draw_arc(Vector2(area.x * 0.50, area.y * 0.48), 210.0, 0.0, TAU, 64, Color(0.28, 0.72, 0.80, 0.14), 2.0)

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
	normal.border_width_left = 2
	normal.border_width_top = 2
	normal.border_width_right = 2
	normal.border_width_bottom = 2
	normal.border_color = bg.lightened(0.18)
	normal.shadow_color = Color(0.02, 0.03, 0.06, 0.35)
	normal.shadow_size = 8
	normal.shadow_offset = Vector2(0.0, 4.0)
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
