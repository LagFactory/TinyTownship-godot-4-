extends BaseItem
class_name ToolItem

enum ToolCategory { PICKAXE, AXE, SWORD, SHOVEL, HAMMER }

@export_category("Tool Stats")
@export var tool_category: ToolCategory = ToolCategory.AXE
@export var tool_tier: int = 1 # e.g., 1 = Wood/Stone, 2 = Iron, 3 = Steel
@export var max_durability: int = 100
@export var harvest_power: float = 15.0 # Damage dealt to enemies or resource nodes

func _init() -> void:
	item_type = ItemType.TOOL
	max_stack_size = 1 # Tools typically do not stack in inventories
