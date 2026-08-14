class_name Carpenter extends ProductionBuilding

@export var sawdust_buildup: float = 0.0
@export var supported_woods: Array[String] = ["oak", "pine"]
@export var products_list: Array[String] = ["furniture", "planks"]

func _ready() -> void:
	super._ready()
	production_type = ProductionBuildingsType.CARPENTER
