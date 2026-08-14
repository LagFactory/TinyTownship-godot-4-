class_name MilitaryBuilding extends Building

@export var defense_rating: int = 10
@export var military_power: int = 1
@export var military_type: MilitaryBuildingsType 


enum MilitaryBuildingsType{
	GUARDTOWER,
	BARRACKS,
	TRAININGCAMP
}

func _ready() -> void:
	building_type = buildingCatagory.MILITARY
