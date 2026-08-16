class_name BuildingData extends Resource

enum BuildingCategory {
	NONE,
	RESIDENTIAL,
	CIVIC,
	PRODUCTION,
	COLLECTION,
	MILITARY
}

# --- STATIC DATA ---
@export var building_id: String
@export var building_name: String
@export var is_unlocked: bool = false
@export var building_level: int
@export var resources_needed: Dictionary = {
	"wood":0,
	"stone":0,
	"mud":0,
	"planks":0,
	"bricks":0} # e.g., {"wood": 50, "stone": 20}
@export var building_type: BuildingCategory
@export var tags_list: Array[String]
@export var max_workers_ocupants: int = 1
@export var upgrades_list: Array[String] = []
@export var max_inventory_size: int = 5

# This holds your temporary .tscn file or future .glb mesh
@export var building_design: PackedScene
@export var rtc_scene: PackedScene
