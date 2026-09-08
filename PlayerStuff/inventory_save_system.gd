extends Node

# Compatibility saveable for older scenes that register this script directly.
signal resource_changed(item_type: String, new_amount: int)
var resources: Dictionary[String, int] = {}

func _ready() -> void:
	SaveManager.register_saveable("inventory", self)

func add_resource(item_type: String, amount: int) -> bool:
	if amount <= 0:
		return false
	var key := item_type.strip_edges().to_lower()
	resources[key] = resources.get(key, 0) + amount
	resource_changed.emit(key, resources[key])
	return true

func spend_resource(item_type: String, amount: int) -> bool:
	var key := item_type.strip_edges().to_lower()
	if amount <= 0 or resources.get(key, 0) < amount:
		return false
	resources[key] -= amount
	resource_changed.emit(key, resources[key])
	return true

func pack_save_data() -> Dictionary:
	return {"resources": resources.duplicate()}

func unpack_save_data(data: Dictionary) -> void:
	resources.clear()
	var saved: Variant = data.get("resources", {})
	if saved is Dictionary:
		for key in saved:
			resources[str(key)] = max(0, int(saved[key]))
			resource_changed.emit(str(key), resources[str(key)])
