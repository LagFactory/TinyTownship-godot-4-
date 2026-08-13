extends Node

# 1. Define the custom signal and the exact data it will pass along
signal resource_changed(item_type: String, new_amount: int)

var resources = {
	"wood": 0,
	"stone": 0
}

func add_resource(item_type: String, amount: int) -> void:
	if resources.has(item_type):
		resources[item_type] += amount
		
		# 2. Emit the signal to the rest of the game
		resource_changed.emit(item_type, resources[item_type])
		
		print("Collected ", amount, " ", item_type, "! Total: ", resources[item_type])
	else:
		print("Error: Item type '", item_type, "' does not exist in inventory.")
