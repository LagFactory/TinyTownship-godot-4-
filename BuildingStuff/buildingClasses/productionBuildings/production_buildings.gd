class_name ProductionBuilding extends Building
@export var items_produced: Array = [] # e.g., "planks", "stone bricks", "iron ingots"
@export var base_production_rate: float = 1.0 
@export var production_type: ProductionBuildingsType

enum ProductionBuildingsType{
	BLACKSMITH,
	CARPENTER
}

func _ready() -> void:

	super._ready()
