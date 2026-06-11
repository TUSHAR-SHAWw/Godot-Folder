extends Resource
class_name LevelScoreResource

const DEFAULT_SCORE:int=9999


@export var level_scores: Dictionary = {}


func get_best_score(level:int)->int:
	return level_scores.get(level,DEFAULT_SCORE)
