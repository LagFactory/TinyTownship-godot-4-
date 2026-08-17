class_name TownHall extends CivicBuilding

@export var tax_rate: float = 0.05
@export var active_policies: Array[String] = []
@export var town_skills_list: Array[String] = []

func _ready() -> void:
	super._ready()
