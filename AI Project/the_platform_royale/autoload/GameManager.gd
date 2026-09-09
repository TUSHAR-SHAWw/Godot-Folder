extends Node

enum GameState { MAIN_MENU, LOBBY, IN_GAME, GAME_OVER }

var current_state: GameState = GameState.MAIN_MENU
var is_single_player_test: bool = true
var total_starting_players: int = 100

func _ready() -> void:
	print("[GameManager] Initialized. Ready for Battle Royale match setup.")

func change_state(new_state: GameState) -> void:
	current_state = new_state
	print("[GameManager] State changed to: ", GameState.keys()[new_state])
	
	match new_state:
		GameState.MAIN_MENU:
			get_tree().change_scene_to_file("res://ui/menus/MainMenu.tscn")
		GameState.LOBBY:
			get_tree().change_scene_to_file("res://ui/menus/Lobby.tscn")
		GameState.IN_GAME:
			get_tree().change_scene_to_file("res://scenes/MainMatch.tscn")
