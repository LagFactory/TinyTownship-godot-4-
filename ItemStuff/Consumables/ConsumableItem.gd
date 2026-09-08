extends BaseItem
class_name ConsumableItem

enum ConsumableEffect { HEALTH, STAMINA, HUNGER, AMMO }

@export_category("Consumable Stats")
@export var effect_type: ConsumableEffect = ConsumableEffect.HEALTH
@export var restore_amount: int = 25

func _init() -> void:
	item_type = ItemType.CONSUMABLE
	max_stack_size = 50 

# Overriding the base function
func use(user: Node) -> bool:
	var methods := {
		ConsumableEffect.HEALTH: "heal",
		ConsumableEffect.STAMINA: "restore_stamina",
		ConsumableEffect.HUNGER: "eat",
		ConsumableEffect.AMMO: "add_ammo"
	}
	var method_name: String = methods.get(effect_type, "")
	if not method_name.is_empty() and user != null and user.has_method(method_name):
		user.call(method_name, restore_amount)
		return true
	return false
