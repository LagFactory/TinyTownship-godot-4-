extends PanelContainer
class_name InventorySlot

# Emitted when the player clicks a slot that holds an item, so the owning UI
# can ask the Inventory to use/consume/equip it.
signal slot_activated(item: BaseItem)

@onready var item_icon: TextureRect = $MarginContainer/ItemIcon
@onready var quantity_label: Label = $QuantityLabel

var _item: BaseItem = null

func _ready() -> void:
	# Initialize as empty
	clear_slot()

func clear_slot() -> void:
	_item = null
	item_icon.texture = null
	quantity_label.text = ""
	tooltip_text = "" # Clears the hover text

func update_slot(item: BaseItem, amount: int) -> void:
	if item == null or amount <= 0:
		clear_slot()
		return
		
	_item = item
	item_icon.texture = item.icon
	
	# Godot's built-in tooltip_text automatically handles the hover reveal
	tooltip_text = item.display_name
	
	# Only show numbers if it is a stackable item or you have more than one
	if amount > 1 or item.is_stackable():
		quantity_label.text = str(amount)
	else:
		quantity_label.text = ""

func _gui_input(event: InputEvent) -> void:
	if _item == null:
		return
	if event is InputEventMouseButton and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		slot_activated.emit(_item)
