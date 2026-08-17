class_name Barracks extends MilitaryBuilding

@export var supported_troop_types: Array[String] = ["infantry", "archers"]
@export var rally_point: Vector3 = Vector3.ZERO

func _ready() -> void:
	super._ready()
