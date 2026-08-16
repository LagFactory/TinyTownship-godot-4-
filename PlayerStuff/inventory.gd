extends Node

# 1. Define the custom signal and the exact data it will pass along
signal resource_changed(item_type: String, new_amount: int)

var resources = {
	
}

func add_resource(item_type: String, amount: int) -> void:
	# If the item doesn't exist in the dictionary yet, create it and initialize it to 0
	if not resources.has(item_type):
		resources[item_type] = 0
		
	# Add the collected amount to the total
	resources[item_type] += amount
	
	# Emit the signal to the rest of the game
	resource_changed.emit(item_type, resources[item_type])
	
	print("Collected ", amount, " ", item_type, "! Total: ", resources[item_type])

func spend_resource(item_type: String, amount: int) -> void:
	# If the item doesn't exist in the dictionary yet, create it and set it to 0
	if not resources.has(item_type):
		resources[item_type] = 0
		
	# Deduct the cost
	resources[item_type] -= amount
	
	# Emit the signal so your UI knows the number went down
	resource_changed.emit(item_type, resources[item_type])
	
	print("Spent ", amount, " ", item_type, "! Remaining: ", resources[item_type])
