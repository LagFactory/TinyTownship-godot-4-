class_name ResourceCollectionBuilding extends Building

# Variables specific to gathering raw materials out in the world
@export var resource_gathered: Array = [] # e.g., "wood", "stone", "iron_ore"
@export var base_gathering_rate: float = 1.0 
@export var colection_type: reasourceColectionBuildingsType 

enum reasourceColectionBuildingsType{
	FORESTER,
	MINE
}

func _ready() -> void:
	# Automatically tell the base class what category this is!
	building_type = buildingCatagory.COLLECTION

# A function to handle the actual gathering logic over time
func gather_resource(amount: int, resource_name: String) -> void:
	var current_total_storage = 0
	for key in inventory:
		current_total_storage += inventory[key]
	if current_total_storage + amount <= max_inventory_size:
		if inventory.has(resource_name):
			inventory[resource_name] += amount
		else:
			inventory[resource_name] = amount
	else:
		var space_left = max_inventory_size - current_total_storage
		if space_left > 0:
			if inventory.has(resource_name):
				inventory[resource_name] += space_left
			else:
				inventory[resource_name] = space_left
