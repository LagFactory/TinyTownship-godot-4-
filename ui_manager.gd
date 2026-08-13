extends CanvasLayer

@onready var pause_menu = $PauseMenu
@onready var inventory_menu = $InventoryMenu

# UI Element References
@onready var resume_button = $PauseMenu/VBoxContainer/ResumeButton
@onready var quit_button = $PauseMenu/VBoxContainer/QuitButtom
@onready var wood_label = $InventoryMenu/VBoxContainer/WoodLabel
@onready var stone_label = $InventoryMenu/VBoxContainer/StoneLabel

func _ready() -> void:
	pause_menu.visible = false
	inventory_menu.visible = false
	
	# Connect the button 'pressed' signals to our custom functions below
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_menu"):
		toggle_pause_menu()
	elif event.is_action_pressed("open_inventory"):
		toggle_inventory_menu()

func toggle_pause_menu() -> void:
	if inventory_menu.visible:
		close_all_menus()
		return
		
	if pause_menu.visible:
		close_all_menus()
	else:
		open_menu(pause_menu)

func toggle_inventory_menu() -> void:
	if pause_menu.visible:
		return
		
	if inventory_menu.visible:
		close_all_menus()
	else:
		open_menu(inventory_menu)

func open_menu(menu_node: Control) -> void:
	menu_node.visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# If the menu opening is the inventory, update the text to show current resources
	if menu_node == inventory_menu:
		update_inventory_display()

func close_all_menus() -> void:
	pause_menu.visible = false
	inventory_menu.visible = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# --- NEW FUNCTIONS FOR INTERACTIVITY ---

func update_inventory_display() -> void:
	# Pull the values directly from the global Inventory dictionary
	wood_label.text = "Wood: " + str(Inventory.resources["wood"])
	stone_label.text = "Stone: " + str(Inventory.resources["stone"])

func _on_resume_pressed() -> void:
	close_all_menus()

func _on_quit_pressed() -> void:
	# This instantly closes the game window
	get_tree().quit()
