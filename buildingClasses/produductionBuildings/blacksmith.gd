class_name Blacksmith extends ProductionBuilding

@export var heat_level: int = 100
@export var supported_metals: Array[String] = ["iron", "steel"]
@export var products_list: Array[String] = ["tools", "weapons"]

func _ready() -> void:
	building_type = "blacksmith"
