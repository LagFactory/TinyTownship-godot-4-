class_name ResidentialBuilding extends Building

# Variables shared by all housing structures
@export var occupants_list: Array[String] = []
@export var max_occupants: int = 4
@export var upgrades_list: Array[String] = []

# Optional: A function to check if the house has open beds
func has_vacancy() -> bool:
	return occupants_list.size() < max_occupants
