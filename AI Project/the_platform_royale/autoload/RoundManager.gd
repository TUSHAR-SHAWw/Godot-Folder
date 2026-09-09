extends Node

var current_round: int = 1
var round_duration: float = 300.0 # 5 minutes per round
var round_timer: float = 300.0
var is_round_active: bool = false
var alive_player_count: int = 100

func _process(delta: float) -> void:
	if not is_round_active:
		return
	
	round_timer -= delta
	if round_timer <= 0:
		_end_current_round()

func start_match(total_players: int) -> void:
	alive_player_count = total_players
	current_round = 1
	round_timer = round_duration
	is_round_active = true
	
	var initial_floors = MathUtils.calculate_floor_scaling(alive_player_count)
	SignalBus.round_started.emit(current_round, alive_player_count, initial_floors)
	print("[RoundManager] Match started with ", alive_player_count, " players on ", initial_floors, " floors.")

func _end_current_round() -> void:
	is_round_active = false
	print("[RoundManager] Round ", current_round, " ended. Evaluating floor collapse...")
	
	current_round += 1
	round_timer = round_duration
	
	# Shrink floors based on current alive count
	var target_floors = MathUtils.calculate_floor_scaling(alive_player_count)
	FloorManager.shrink_floors_to(target_floors)
	
	is_round_active = true
	SignalBus.round_started.emit(current_round, alive_player_count, target_floors)

func notify_player_eliminated(player_id: String) -> void:
	alive_player_count -= 1
	print("[RoundManager] Player eliminated. Remaining alive: ", alive_player_count)
	if alive_player_count <= 1:
		is_round_active = false
		SignalBus.round_ended.emit(player_id)
