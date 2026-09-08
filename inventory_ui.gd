extends Control

@export var slot_scene: PackedScene # Drag your inventory_slot.tscn here in the Inspector
@onready var grid: GridContainer = $MarginContainer/GridContainer

func _ready() -> void:
	# Hide the inventory by default
	visible = false
	
	# Connect to the global inventory signals
	Inventory.item_changed.connect(_on_inventory_updated)
	Inventory.resource_changed.connect(_on_resource_updated)
	
	refresh_ui()

func refresh_ui() -> void:
	# 1. Clear existing slots to prevent duplicates
	for child in grid.get_children():
		child.queue_free()
		
	# 2. Rebuild the grid based on current inventory state
	for key in Inventory.items:
		var item_data: BaseItem = Inventory.items[key]
		var amount: int = Inventory.resources.get(key, 1)
		
		var new_slot = slot_scene.instantiate() as InventorySlot
		grid.add_child(new_slot)
		new_slot.update_slot(item_data, amount)

# Signal callbacks to update UI if it is open while collecting items
func _on_inventory_updated(_item: BaseItem, _new_amount: int) -> void:
	if visible:
		refresh_ui()

func _on_resource_updated(_item_type: String, _new_amount: int) -> void:
	if visible:
		refresh_ui()
