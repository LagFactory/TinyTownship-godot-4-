class_name Building extends Node3D

enum BuildingCategory {
	NONE,
	RESIDENTIAL,
	CIVIC,
	PRODUCTION,
	COLLECTION,
	MILITARY
}


@export var building_id: String
@export var building_name: String
@export var building_level: int
@export var resources_needed: Dictionary # e.g., {"wood": 50, "stone": 20}
@export var building_type: BuildingCategory
@export var tags_list: Array[String]
@export var worker_ocupants_list: Array[String] = []
@export var max_workers_ocupants: int = 1
@export var upgrades_list: Array[String] = []
@export var inventory : Dictionary = {}
@export var max_inventory_size : int = 5

# This holds your temporary .tscn file
@export var building_design: PackedScene 

func _ready() -> void:
	initialize_visuals()

# A dedicated function you can override later
func initialize_visuals() -> void:
	if building_design != null:
		var visuals = building_design.instantiate()
		add_child(visuals)
		
func add_to_inventory(amount: int, item_name: String) -> void:
	var current_total_storage = 0
	
	# Calculate current used space
	for key in inventory:
		current_total_storage += inventory[key]
		
	# Check if the full amount fits
	if current_total_storage + amount <= max_inventory_size:
		if inventory.has(item_name):
			inventory[item_name] += amount
		else:
			inventory[item_name] = amount
	else:
		# If it does not fit perfectly, calculate the remaining space
		var space_left = max_inventory_size - current_total_storage
		
		if space_left > 0:
			if inventory.has(item_name):
				inventory[item_name] += space_left
			else:
				inventory[item_name] = space_left
