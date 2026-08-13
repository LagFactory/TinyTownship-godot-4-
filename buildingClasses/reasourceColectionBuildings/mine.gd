class_name Mine extends ResourceCollectionBuilding

@export var supported_ores: Array[String] = ["stone", "iron", "coal"]
@export var mine_depth: int = 1

func _ready() -> void:
	building_type = "mine"
	resource_gathered = "stone" # Default starting resource
