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
		
	# --- THE NEGATIVE GUARD ---
	# Check if subtracting the amount would drop the total below zero
	if resources[item_type] < amount:
		print("Warning: Attempted to spend ", amount, " ", item_type, " but only have ", resources[item_type], "!")
		return # Abort the function immediately so no math or signals execute
		
	# Deduct the cost safely
	resources[item_type] -= amount
	
	# Emit the signal so your UI knows the number went down
	resource_changed.emit(item_type, resources[item_type])
	
	print("Spent ", amount, " ", item_type, "! Remaining: ", resources[item_type])
	
func pack_save_data() -> Dictionary:
	# Since your resources are already in a dictionary, 
	# we can just return it directly!
	var data: Dictionary = {}
	data["resources"] = resources 
	return data

func unpack_save_data(data: Dictionary) -> void:
	if data.has("resources"):
		resources = data["resources"]
		
		# Force the UI to update by emitting your existing signal
		# We can just pass empty/dummy values for the signal parameters 
		# since the UI rebuilds the whole list anyway
		resource_changed.emit("", 0) 
		print("Inventory loaded successfully.")
