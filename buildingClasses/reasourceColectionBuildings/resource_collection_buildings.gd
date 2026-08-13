class_name ResourceCollectionBuilding extends Building

# Variables for managing the workforce
@export var worker_list: Array[String] = []
@export var max_workers: int = 1
@export var upgrades_list: Array[String] = []

# Variables specific to gathering raw materials out in the world
@export var resource_gathered: String = "wood" # e.g., "wood", "stone", "iron_ore"
@export var base_gathering_rate: float = 1.0 
@export var current_storage: int = 0
@export var max_storage: int = 100

# A function to check if there is room for a new worker
func can_assign_worker() -> bool:
	return worker_list.size() < max_workers

# A function to handle the actual gathering logic over time
func gather_resource(amount: int) -> void:
	if current_storage + amount <= max_storage:
		current_storage += amount
	else:
		current_storage = max_storage
