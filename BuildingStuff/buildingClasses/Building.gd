class_name Building extends Node3D

# 1. The slot for your new .tres data file
@export var data: BuildingData

# 2. DYNAMIC STATE (Variables that change during gameplay)
@export var worker_ocupants_list: Array[String] = []
@export var inventory: Dictionary = {}

@onready var building_name_label: Label3D = $BuildingName

func _ready() -> void:
	# Add a safety check in case you forget to assign a .tres file in the editor
	if data != null:
		initialize_visuals()
		update_debug_label()
	else:
		push_warning("Building data is missing on node: ", name)

func initialize_visuals() -> void:
	if data.building_design != null:
		var visuals = data.building_design.instantiate()
		add_child(visuals)
		
func update_debug_label() -> void:
	# Always ensure the node actually exists before trying to change its text
	if building_name_label != null:
		
		# OPTION A: Display the custom string name (e.g., "Village Town Hall")
		building_name_label.text = data.building_name
		
		# OPTION B: If you specifically wanted the exact Category (e.g., "CIVIC")
		# Uncomment the line below instead. It looks up the Enum dictionary keys:
		# building_name_label.text = BuildingData.BuildingCategory.keys()[data.building_type]

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
