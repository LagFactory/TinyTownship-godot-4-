extends PanelContainer
class_name InventorySlot

@onready var item_icon: TextureRect = $MarginContainer/ItemIcon
@onready var quantity_label: Label = $QuantityLabel

func _ready() -> void:
	# Initialize as empty
	clear_slot()

func clear_slot() -> void:
	item_icon.texture = null
	quantity_label.text = ""
	tooltip_text = "" # Clears the hover text

func update_slot(item: BaseItem, amount: int) -> void:
	if item == null or amount <= 0:
		clear_slot()
		return
		
	item_icon.texture = item.icon
	
	# Godot's built-in tooltip_text automatically handles the hover reveal
	tooltip_text = item.display_name
	
	# Only show numbers if it is a stackable item or you have more than one
	if amount > 1 or item.is_stackable():
		quantity_label.text = str(amount)
	else:
		quantity_label.text = ""
