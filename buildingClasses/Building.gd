class_name Building extends Node3D

@export var building_id: String
@export var building_name: String
@export var resources_needed: Dictionary # e.g., {"wood": 50, "stone": 20}
@export var level: int = 1
@export var building_type: String
@export var building_type_variant: String
@export var tags_list: Array[String]

# This holds your temporary .tscn file
@export var building_design: PackedScene 

func _ready() -> void:
	initialize_visuals()

# A dedicated function you can override later
func initialize_visuals() -> void:
	if building_design != null:
		var visuals = building_design.instantiate()
		add_child(visuals)
