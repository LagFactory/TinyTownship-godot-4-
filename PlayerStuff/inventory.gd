extends Node

signal resource_changed(item_type: String, new_amount: int)
signal item_changed(item: BaseItem, new_amount: int)

# String keys preserve the original save format and add_resource API.
var resources: Dictionary[String, int] = {}
var items: Dictionary[String, BaseItem] = {}

func _ready() -> void:
	SaveManager.register_saveable("inventory", self)

func add_item(item: BaseItem, amount: int = 1) -> bool:
	if item == null or amount <= 0 or not item.validate():
		return false
	var key := item.get_item_key()
	var total := resources.get(key, 0) + amount
	if total > item.max_stack_size and item.max_stack_size == 1:
		return false
	resources[key] = total
	items[key] = item
	item_changed.emit(item, total)
	resource_changed.emit(key, total)
	return true

func remove_item(item: BaseItem, amount: int = 1) -> bool:
	if item == null or amount <= 0:
		return false
	return spend_resource(item.get_item_key(), amount)

func has_item(item: BaseItem, amount: int = 1) -> bool:
	return item != null and amount > 0 and resources.get(item.get_item_key(), 0) >= amount

func add_resource(item_type: String, amount: int) -> bool:
	if item_type.strip_edges().is_empty() or amount <= 0:
		return false
	var key := item_type.strip_edges().to_lower()
	resources[key] = resources.get(key, 0) + amount
	resource_changed.emit(key, resources[key])
	return true

func spend_resource(item_type: String, amount: int) -> bool:
	var key := item_type.strip_edges().to_lower()
	if key.is_empty() or amount <= 0 or resources.get(key, 0) < amount:
		return false
	resources[key] -= amount
	if resources[key] == 0:
		resources.erase(key)
		items.erase(key)
	resource_changed.emit(key, resources.get(key, 0))
	return true

func use_item(item: BaseItem, user: Node) -> bool:
	if item == null or not has_item(item):
		return false
	if not item.use(user):
		return false
	return remove_item(item)

func pack_save_data() -> Dictionary:
	var item_records: Dictionary = {}
	for key in items:
		var item: BaseItem = items[key]
		var record := {"amount": resources.get(key, 0)}
		if not item.resource_path.is_empty():
			record["path"] = item.resource_path
		item_records[key] = record
	return {"resources": resources.duplicate(), "items": item_records}

func unpack_save_data(data: Dictionary) -> void:
	resources.clear()
	items.clear()
	var saved: Variant = data.get("resources", {})
	if saved is Dictionary:
		for key in saved:
			var amount := int(saved[key])
			if amount > 0:
				resources[str(key).to_lower()] = amount
	var saved_items: Variant = data.get("items", {})
	if saved_items is Dictionary:
		for key in saved_items:
			var record: Variant = saved_items[key]
			if record is Dictionary:
				var path := str(record.get("path", ""))
				if not path.is_empty() and ResourceLoader.exists(path):
					var item := ResourceLoader.load(path) as BaseItem
					if item != null and item.validate():
						items[str(key).to_lower()] = item
	for key in resources:
		resource_changed.emit(key, resources[key])
