class_name Building extends Node3D

enum buildingCatagory {
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
@export var level: int = 1
@export var building_type: buildingCatagory
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
