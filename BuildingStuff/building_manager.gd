extends Node

@export var available_buildings: Array[BuildingData] = []

var _active_index: int = 0

func get_active_building() -> BuildingData:
	if available_buildings.is_empty():
		return null
	return available_buildings[_active_index]

func cycle_next_building() -> void:
	if available_buildings.is_empty():
		return
	_active_index = (_active_index + 1) % available_buildings.size()
	print("Active building: ", available_buildings[_active_index].building_name)
