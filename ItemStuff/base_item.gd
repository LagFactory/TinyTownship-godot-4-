extends Resource
class_name BaseItem

enum ItemType { RESOURCE, CONSUMABLE, TOOL, EQUIPMENT, QUEST, COMPONENT }

@export_category("Basic Info")
@export var id: String = "base_item"
@export var display_name: String = "Unknown Item"
@export_multiline var description: String = ""
@export var item_type: ItemType = ItemType.RESOURCE

@export_category("Visuals")
@export var icon: Texture2D 
@export var drop_mesh: PackedScene 

@export_category("Stats")
@export var max_stack_size: int = 99
@export var weight: float = 0.1
@export var base_value: int = 0

# Helper function to check if stacking is possible
func is_stackable() -> bool:
	return max_stack_size > 1

func get_inspection_text() -> String:
	return display_name + ": " + description

# Virtual function meant to be overridden by inherited items (e.g., ToolItem, ConsumableItem)
func use(_user: Node) -> bool:
	print("This item has no use effect.")
	return false
