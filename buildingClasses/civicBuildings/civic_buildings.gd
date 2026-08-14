class_name CivicBuilding extends Building
@export var CivilScore: int 
@export var civic_type: CivilBuildingsType

enum CivilBuildingsType{
	TOWNHALL,
	COURIER
}

func _ready() -> void:
	building_type = buildingCatagory.CIVIC
