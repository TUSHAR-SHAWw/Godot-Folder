extends Node
@onready var sc_dis: Label = $score_display

var score=0

func add_point():
	score+=1
	sc_dis.text="Hello"+str(score)
