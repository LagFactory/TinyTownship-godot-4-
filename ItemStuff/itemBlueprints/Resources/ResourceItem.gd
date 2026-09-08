extends BaseItem
class_name ResourceItem

enum MaterialCategory { WOOD, STONE, METAL, ORGANIC, DIRT }

@export_category("Resource Properties")
@export var material_category: MaterialCategory = MaterialCategory.WOOD

func _init() -> void:
	# Set default values for this specific type of item
	item_type = ItemType.RESOURCE
	max_stack_size = 99
