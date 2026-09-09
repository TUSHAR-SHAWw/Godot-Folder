class_name Lobby
extends Control

var selected_lobby_items: Array = []

func select_item(item_name: String) -> void:
	if selected_lobby_items.has(item_name):
		selected_lobby_items.erase(item_name)
	elif selected_lobby_items.size() < 2:
		selected_lobby_items.append(item_name)
	print("[Lobby] Pre-round items selected: ", selected_lobby_items)

func start_match() -> void:
	print("[Lobby] Deploying into tower...")
	GameManager.change_state(GameManager.GameState.IN_GAME)
