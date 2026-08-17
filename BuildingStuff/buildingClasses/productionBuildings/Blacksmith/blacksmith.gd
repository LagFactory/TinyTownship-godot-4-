class_name Blacksmith extends ProductionBuilding

@export var heat_level: int = 100
@export var supported_metals: Array[String] = ["iron", "steel"]


func _ready() -> void:
	super._ready()
