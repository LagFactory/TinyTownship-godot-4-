class_name MilitaryBuilding extends Building

@export var garrison_list: Array[String] = []
@export var max_garrison: int = 5
@export var defense_rating: int = 10
@export var upgrades_list: Array[String] = []

func has_garrison_space() -> bool:
	return garrison_list.size() < max_garrison
