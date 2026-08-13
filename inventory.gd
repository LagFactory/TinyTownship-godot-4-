extends Node

var resources = {
	"wood": 0,
	"stone": 0
}

func add_resource(item_type: String, amount: int):
	if resources.has(item_type):
		resources[item_type] += amount
		print("Collected ", amount, " ", item_type, "! Total: ", resources[item_type])
		
	else:
		print("Error: Item type '", item_type, "' does not exist in inventory.")
