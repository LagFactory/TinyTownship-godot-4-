class_name GuardTower extends MilitaryBuilding

@export var sight_radius: float = 50.0
@export var alarm_active: bool = false

func _ready() -> void:
	super._ready()
	military_type = MilitaryBuildingsType.GUARDTOWER
