class_name Courier extends CivicBuilding

@export var delivery_speed_multiplier: float = 1.2
@export var connected_routes: Array[String] = []

func _ready() -> void:
	super._ready()
	civic_type = CivilBuildingsType.COURIER
