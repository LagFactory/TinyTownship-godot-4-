class_name ResourceCollectionBuilding extends Building

# Variables specific to gathering raw materials out in the world
@export var resource_gathered: Array = [] # e.g., "wood", "stone", "iron_ore"
@export var base_gathering_rate: float = 1.0 
@export var collection_type: ResourceCollectionBuildingsType 

enum ResourceCollectionBuildingsType{
	FORESTER,
	MINE
}

func _ready() -> void:
	# Automatically tell the base class what category this is!
	
	super._ready()
