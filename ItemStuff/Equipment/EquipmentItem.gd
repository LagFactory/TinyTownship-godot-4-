extends BaseItem
class_name EquipmentItem

enum EquipmentSlot { HEAD, CHEST, LEGS, FEET, ACCESSORY }

@export_category("Equipment Stats")
@export var slot: EquipmentSlot = EquipmentSlot.CHEST
@export var defense_bonus: int = 5
@export var movement_penalty: float = 0.0 # Heavy armor might slow the player down

func _init() -> void:
	item_type = ItemType.EQUIPMENT
	max_stack_size = 1
