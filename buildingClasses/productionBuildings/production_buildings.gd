class_name ProductionBuilding extends Building
@export var items_produced: Array = [] # e.g., "planks", "stone bricks", "iron ingots"
@export var base_production_rate: float = 1.0 
@export var production_type: ProductionBuildingsType

enum ProductionBuildingsType{
	BLACKSMITH,
	CARPENTER
}

func _ready() -> void:
	building_type = buildingCatagory.PRODUCTION


# A function to handle the actual gathering logic over time
func produce_item(amount: int, item_name: String) -> void:
	var current_total_storage = 0
	for key in inventory:
		current_total_storage += inventory[key]
	if current_total_storage + amount <= max_inventory_size:
		if inventory.has(item_name):
			inventory[item_name] += amount
		else:
			inventory[item_name] = amount
	else:
		var space_left = max_inventory_size - current_total_storage
		if space_left > 0:
			if inventory.has(item_name):
				inventory[item_name] += space_left
			else:
				inventory[item_name] = space_left
