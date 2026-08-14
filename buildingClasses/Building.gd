class_name Building extends Node3D

# 1. The slot for your new .tres data file
@export var data: BuildingData

# 2. DYNAMIC STATE (Variables that change during gameplay)
@export var worker_ocupants_list: Array[String] = []
@export var inventory: Dictionary = {}

func _ready() -> void:
	# Add a safety check in case you forget to assign a .tres file in the editor
	if data != null:
		initialize_visuals()
	else:
		push_warning("Building data is missing on node: ", name)

func initialize_visuals() -> void:
	if data.building_design != null:
		var visuals = data.building_design.instantiate()
		add_child(visuals)

func add_to_inventory(amount: int, item_name: String) -> void:
	if data == null:
		return
		
	var current_total_storage = 0
	
	# Calculate current used space
	for key in inventory:
		current_total_storage += inventory[key]
		
	# Check if the full amount fits using the data resource
	if current_total_storage + amount <= data.max_inventory_size:
		if inventory.has(item_name):
			inventory[item_name] += amount
		else:
			inventory[item_name] = amount
	else:
		# If it does not fit perfectly, calculate the remaining space using the data resource
		var space_left = data.max_inventory_size - current_total_storage
		
		if space_left > 0:
			if inventory.has(item_name):
				inventory[item_name] += space_left
			else:
				inventory[item_name] = space_left
