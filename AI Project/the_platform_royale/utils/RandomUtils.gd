class_name RandomUtils
extends Node

static func pick_random_weighted(items: Array, weights: Array) -> Variant:
	var total_weight: float = 0.0
	for w in weights:
		total_weight += w
	
	var rand_val: float = randf() * total_weight
	var current_weight: float = 0.0
	for i in range(items.size()):
		current_weight += weights[i]
		if rand_val <= current_weight:
			return items[i]
	return items[0]
