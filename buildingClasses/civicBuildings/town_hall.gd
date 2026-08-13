class_name TownHall extends CivicBuilding

@export var tax_rate: float = 0.05
@export var active_policies: Array[String] = []

func _ready() -> void:
	building_type = "town_hall"
