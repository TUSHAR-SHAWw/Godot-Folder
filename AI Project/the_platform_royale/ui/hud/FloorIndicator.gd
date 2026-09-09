class_name FloorIndicator
extends Label

func update_floor(current_floor: int, total_floors: int) -> void:
	text = "Floor " + str(current_floor) + " / " + str(total_floors)
