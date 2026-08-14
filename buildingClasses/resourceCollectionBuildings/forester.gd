class_name Forester extends ResourceCollectionBuilding

@export var replanting_enabled: bool = true
@export var tree_growth_speed: float = 1.0

func _ready() -> void:
	super._ready()
	colection_type = reasourceColectionBuildingsType.FORESTER
