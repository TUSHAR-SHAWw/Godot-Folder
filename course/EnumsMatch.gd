@tool
extends EditorScript


enum Race { HOBBIT, ELF, DWARF, HUMAN, ORC, WIZARD }
enum State { IDLE, RUN, JUMP, DEAD }


func identify_race(the_race: Race) -> void:
	
	match the_race:
		Race.HOBBIT:
			print("Race.HOBBIT")
		Race.DWARF, Race.WIZARD:
			print("Race.DWARF or Race.WIZARD")
		_:
			print("Race is not what we need") 
	
	if the_race == Race.HOBBIT:
		print("Race.HOBBIT")
	elif the_race == Race.DWARF:
		print("Race.DWARF")
	else:
		print("Race is not what we need")


# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	var aragorn_race: Race = Race.HUMAN
	var legolas_race: Race = Race.ELF
	var gimli_race: Race = Race.DWARF
	
	identify_race(gimli_race)
	identify_race(legolas_race)
	
	print(aragorn_race)
	print(legolas_race)
	print(gimli_race)
	print(Race.keys()[gimli_race])






