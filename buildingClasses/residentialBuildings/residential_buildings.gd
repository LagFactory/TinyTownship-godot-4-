class_name ResidentialBuilding extends Building
@export var comfort_factor: int
@export var residential_type: residentialBuildingsType


func _ready() -> void:
	super._ready()

enum residentialBuildingsType{
	HOUSE,
	DORM
}
