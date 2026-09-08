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

func use(user: Node) -> bool:
	if user != null and user.has_method("equip_item"):
		user.equip_item(self)
		return true
	return false
