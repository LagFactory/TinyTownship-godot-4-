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
	if effect_type == ConsumableEffect.HEALTH:
		# Assuming your player script has a heal() function
		if user.has_method("heal"):
			user.heal(restore_amount)
			return true # Item was successfully used
			
	elif effect_type == ConsumableEffect.HUNGER:
		if user.has_method("eat"):
			user.eat(restore_amount)
			return true
			
	return false # Failsafe if the item could not be used
