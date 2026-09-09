extends Node2D

## Game coordinator: owns the game state machine, survival timer/score, and the
## best-score persistence. The DangerManager and UI are driven from here.

enum State { MENU, PLAYING, GAME_OVER }

const SAVE_PATH := "user://dttr_config.cfg"
const BEST_KEY := "best_score"

var state := State.MENU
var elapsed := 0.0
var best := 0

@onready var danger_manager := $DangerManager
@onready var player := $Player
@onready var ui := $UI

func _ready() -> void:
	best = _load_best()
	ui.play_pressed.connect(start_game)
	ui.try_again_pressed.connect(start_game)
	ui.menu_pressed.connect(_enter_menu)
	_enter_menu()

func _process(delta: float) -> void:
	if state == State.PLAYING:
		elapsed += delta
		ui.update_timer(elapsed)

func _unhandled_input(event: InputEvent) -> void:
	# Enter / Space start or restart instantly (buttons handle their own input,
	# so this won't double-trigger while a button has focus).
	if event.is_action_pressed("ui_accept"):
		if state == State.MENU or state == State.GAME_OVER:
			start_game()

func start_game() -> void:
	elapsed = 0.0
	state = State.PLAYING
	player.reset()
	danger_manager.start(player)
	ui.show_hud(best)

func _enter_menu() -> void:
	danger_manager.stop()
	state = State.MENU
	ui.show_menu(best)

func _on_player_died() -> void:
	if state != State.PLAYING:
		return
	state = State.GAME_OVER
	danger_manager.stop()
	var score := _score()
	if score > best:
		best = score
		_save_best()
	ui.show_game_over(score, best)

func _score() -> int:
	return int(elapsed)

func _load_best() -> int:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) == OK:
		return int(cfg.get_value("meta", BEST_KEY, 0))
	return 0

func _save_best() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("meta", BEST_KEY, best)
	cfg.save(SAVE_PATH)
