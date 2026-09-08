extends BaseItem
class_name ComponentItem

enum ComponentCategory { STRUCTURAL, MECHANICAL, ELECTRICAL, CHEMICAL, MISC }

@export_category("Component Stats")
@export var component_category: ComponentCategory = ComponentCategory.STRUCTURAL
@export var component_tier: int = 1 # Useful for gating advanced recipes (e.g., Tier 1 = Wood Plank, Tier 2 = Iron Beam)

func _init() -> void:
	item_type = ItemType.COMPONENT 
	max_stack_size = 99
