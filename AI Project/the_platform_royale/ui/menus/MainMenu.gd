class_name MainMenu
extends Control

func _on_start_button_pressed() -> void:
	print("[MainMenu] Start Game pressed. Switching to Lobby...")
	GameManager.change_state(GameManager.GameState.LOBBY)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
