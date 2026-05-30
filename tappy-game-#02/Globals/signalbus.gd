extends Node
signal point_scored

signal plane_die

func emit_plane_die()->void:
	plane_die.emit()

func emit_point_scored()->void:
	point_scored.emit()
