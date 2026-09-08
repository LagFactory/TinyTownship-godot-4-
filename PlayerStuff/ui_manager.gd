extends CanvasLayer

@onready var pause_menu = $PauseMenu
# Point this to the newly instantiated grid scene
@onready var inventory_menu = $InventoryUI

# UI Element References
@onready var resume_button = $PauseMenu/VBoxContainer/ResumeButton
@onready var quit_button = $PauseMenu/VBoxContainer/QuitButton
@onready var save_button = $PauseMenu/VBoxContainer/SaveButton
@onready var load_button = $PauseMenu/VBoxContainer/LoadButton

func _ready() -> void:
	pause_menu.visible = false
	inventory_menu.visible = false

	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)

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

	# Trigger the grid rebuild when opening the inventory
	if menu_node == inventory_menu:
		inventory_menu.refresh_ui()

func close_all_menus() -> void:
	pause_menu.visible = false
	inventory_menu.visible = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_pressed() -> void:
	close_all_menus()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_save_pressed() -> void:
	SaveManager.save_game()

func _on_load_pressed() -> void:
	SaveManager.load_game()
	close_all_menus()
