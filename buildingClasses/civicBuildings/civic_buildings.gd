class_name CivicBuilding extends Building

# Variables that dictate settlement-wide progression
@export var town_level: int = 1
@export var town_skills_list: Array[String] = []

# Optional: A function to process leveling up the settlement
func increase_town_level() -> void:
	town_level += 1
