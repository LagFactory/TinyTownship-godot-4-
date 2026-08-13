class_name House extends ResidentialBuilding

@export var family_name: String = "Unassigned"

func _ready() -> void:
	max_occupants = 4 # Houses usually hold a small family unit
	building_type = "house"
