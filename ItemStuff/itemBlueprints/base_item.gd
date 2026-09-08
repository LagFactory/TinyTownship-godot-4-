extends Resource
class_name BaseItem

enum ItemType { RESOURCE, CONSUMABLE, TOOL, EQUIPMENT, QUEST, COMPONENT }

@export_category("Basic Info")
@export var id: String = "base_item"
@export var display_name: String = "Unknown Item"
@export_multiline var description: String = ""
var item_type: ItemType = ItemType.RESOURCE

@export_category("Visuals")
@export var icon: Texture2D 
@export var drop_mesh: PackedScene 

@export_category("Stats")
@export_range(1, 9999, 1) var max_stack_size: int = 99
@export_range(0.0, 9999.0, 0.01) var weight: float = 0.1
@export_range(0, 999999, 1) var base_value: int = 0

# Helper function to check if stacking is possible
func is_stackable() -> bool:
	return max_stack_size > 1

func get_item_key() -> String:
	return id.strip_edges().to_lower()

func is_valid() -> bool:
	return not get_item_key().is_empty() and not display_name.strip_edges().is_empty() \
		and max_stack_size > 0 and weight >= 0.0 and base_value >= 0

func validate() -> bool:
	if not is_valid():
		push_warning("Invalid item definition: id, stack size, and weight must be valid.")
		return false
	return true

func get_inspection_text() -> String:
	return display_name + ": " + description

func use(_user: Node) -> bool:
	return false
	
	
