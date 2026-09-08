extends Node

signal resource_changed(item_type: String, new_amount: int)
signal item_changed(item: BaseItem, new_amount: int)

var resources: Dictionary[String, int] = {}
var items: Dictionary[String, BaseItem] = {}
var _unique_id_counter: int = 0

func _ready() -> void:
	SaveManager.register_saveable("inventory", self)

# --- ITEM MANAGEMENT ---

func _get_inventory_key(item: BaseItem) -> String:
	var base_key: String = item.get_item_key()
	if not item.is_stackable():
		_unique_id_counter += 1
		return base_key + "_" + str(_unique_id_counter)
	return base_key

func add_item(item: BaseItem, amount: int = 1) -> bool:
	if item == null or amount <= 0 or not item.validate():
		return false
		
	var key: String = _get_inventory_key(item)
	var actual_amount: int = amount
	
	if not item.is_stackable() and amount > 1:
		actual_amount = 1
		
	var total: int = resources.get(key, 0) + actual_amount
	if total > item.max_stack_size:
		return false
		
	resources[key] = total
	items[key] = item
	
	item_changed.emit(item, total)
	resource_changed.emit(item.get_item_key(), get_total_resource_amount(item.get_item_key()))
	return true

func remove_item(item: BaseItem, amount: int = 1) -> bool:
	if item == null or amount <= 0:
		return false
		
	var target_key: String = ""
	if item.is_stackable():
		target_key = item.get_item_key()
	else:
		for key in items:
			if items[key] == item:
				target_key = key
				break
				
	if target_key == "" or resources.get(target_key, 0) < amount:
		return false
		
	resources[target_key] -= amount
	if resources[target_key] == 0:
		resources.erase(target_key)
		items.erase(target_key)
		
	item_changed.emit(item, resources.get(target_key, 0))
	resource_changed.emit(item.get_item_key(), get_total_resource_amount(item.get_item_key()))
	return true

func has_item(item: BaseItem, amount: int = 1) -> bool:
	if item == null or amount <= 0:
		return false
		
	if item.is_stackable():
		return resources.get(item.get_item_key(), 0) >= amount
		
	for key in items:
		if items[key] == item:
			return resources.get(key, 0) >= amount
	return false

# --- STRING-BASED CRAFTING / BUILDING ---

func get_total_resource_amount(base_id: String) -> int:
	var target_key: String = base_id.strip_edges().to_lower()
	var total_found: int = 0
	for key in resources.keys():
		if key == target_key or key.begins_with(target_key + "_"):
			total_found += resources[key]
	return total_found

func spend_resource(base_id: String, amount: int) -> bool:
	var target_key: String = base_id.strip_edges().to_lower()
	if target_key.is_empty() or amount <= 0:
		return false
		
	var total_available: int = get_total_resource_amount(target_key)
	if total_available < amount:
		return false
		
	var amount_left: int = amount
	var keys_to_remove: Array[String] = []
	
	for key in resources.keys():
		if amount_left <= 0:
			break
			
		if key == target_key or key.begins_with(target_key + "_"):
			var available: int = resources[key]
			var deduct: int = min(available, amount_left)
			
			resources[key] -= deduct
			amount_left -= deduct
			
			if resources[key] == 0:
				keys_to_remove.append(key)
				
	for k in keys_to_remove:
		resources.erase(k)
		items.erase(k)
		
	resource_changed.emit(target_key, get_total_resource_amount(target_key))
	return true

func use_item(item: BaseItem, user: Node) -> bool:
	if item == null or not has_item(item):
		return false
	if not item.use(user):
		return false
	return remove_item(item)

# --- SAVE & LOAD ---

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
						# Ensure unique objects remain unique after loading
						if not item.is_stackable():
							item = item.duplicate()
						items[str(key).to_lower()] = item
						
	for key in resources:
		resource_changed.emit(key, resources[key])
