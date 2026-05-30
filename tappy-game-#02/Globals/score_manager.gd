extends Node

const  SCOREPATH :String="user://tappy.tres"

var high_score:int=0:
	get:
		return high_score
	set(value):
		if(value>high_score):
			high_score=value
			save_high_score()
var points:int=0:
	get:
		return points
	set(value):
		points=value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_high_score()
	Signalbus.point_scored.connect(update_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_score() -> void:
	points+=1
	
	
func load_high_score()->void:
	if ResourceLoader.exists(SCOREPATH):
		var hsr= load(SCOREPATH)
		if hsr:
			high_score=hsr.high_score
	
func save_high_score()->void:
	var hsr= HighScoreResourse.new()
	hsr.high_score=high_score
	ResourceSaver.save(hsr,SCOREPATH)
