class_name CivicBuilding extends Building
@export var civil_score: int 
@export var civic_type: CivilBuildingsType

enum CivilBuildingsType{
	TOWNHALL,
	COURIER
}

func _ready() -> void:
	super._ready()
