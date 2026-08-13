class_name ProductionBuilding extends Building

# Variables shared by all production-type buildings
@export var worker_list: Array[String] = []
@export var max_workers: int = 1
@export var upgrades_list: Array[String] = []

# Optional: A function to check if there is room for a new worker
func can_assign_worker() -> bool:
	return worker_list.size() < max_workers
