extends CanvasLayer

@onready var pause_menu = $PauseMenu
@onready var inventory_menu = $InventoryMenu

# UI Element References
@onready var resume_button = $PauseMenu/VBoxContainer/ResumeButton
@onready var quit_button = $PauseMenu/VBoxContainer/QuitButton
@onready var save_button = $PauseMenu/VBoxContainer/SaveButton
@onready var load_button = $PauseMenu/VBoxContainer/LoadButton

# We replaced the hardcoded labels with a single dynamic label
@onready var resources_label = $InventoryMenu/VBoxContainer/ResourcesLabel

func _ready() -> void:
	pause_menu.visible = false
	inventory_menu.visible = false
	
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)
	
	Inventory.resource_changed.connect(_on_resource_changed)
	
	update_inventory_display()

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
	
	if menu_node == inventory_menu:
		update_inventory_display()

func close_all_menus() -> void:
	pause_menu.visible = false
	inventory_menu.visible = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# --- FUNCTIONS FOR INTERACTIVITY & SIGNALS ---

func update_inventory_display() -> void:
	# Start the text block with your title and a newline character (\n)
	var display_text = "Resources:\n"
	
	# Loop through every key that currently exists in the dictionary
	for item_name in Inventory.resources:
		var amount = Inventory.resources[item_name]
		
		# Append the item, its amount, and a new line to the string block
		display_text += str(item_name) + ": " + str(amount) + "\n"
		
	# Apply the compiled text to the single UI label
	resources_label.text = display_text

func _on_resume_pressed() -> void:
	close_all_menus()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_resource_changed(_item_type: String, _new_amount: int) -> void:
	# Because the label is completely dynamic, any change to any resource 
	# just requires us to rebuild and refresh the text block!
	update_inventory_display()
	
func _on_save_pressed() -> void:
	# Calls the save function we built in the Autoload
	SaveManager.save_game()
	
func _on_load_pressed() -> void:
	# Calls the load function in the Autoload
	SaveManager.load_game()
	
	# Close the pause menu so the player returns to the game 
	# and can see their loaded state
	close_all_menus()
