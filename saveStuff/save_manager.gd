extends Node

const SAVE_PATH = "user://saveStuff/save_game.sav"
const DEBUG_SAVE_PATH = "user://saveStuff/save_game.json"

@export var is_debug_mode: bool = true

func save_game() -> void:
	var master_data: Dictionary = {}
	
	# 1. Ask the Inventory for its data
	master_data["inventory"] = Inventory.pack_save_data()
	master_data["player"] = PlayerManager.pack_save_data()
	
	# Ensure the save folder exists
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("saveStuff"):
		dir.make_dir("saveStuff")
	
	# 2. Save binary
	var bin_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if bin_file:
		bin_file.store_var(master_data) 
		bin_file.close()
	else:
		printerr("Failed to open binary save file for writing.")

	# 3. Save JSON debug file
	if is_debug_mode:
		var json_file = FileAccess.open(DEBUG_SAVE_PATH, FileAccess.WRITE)
		if json_file:
			var json_string = JSON.stringify(master_data, "\t") 
			json_file.store_string(json_string)
			json_file.close()
			
	print("Game saved successfully.")

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return
		
	var bin_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if bin_file:
		var master_data: Dictionary = bin_file.get_var()
		bin_file.close()
		
		# 4. Give the data back to the Inventory
		if master_data.has("inventory"):
			Inventory.unpack_save_data(master_data["inventory"])
		if master_data.has("player"):
			PlayerManager.unpack_save_data(master_data["player"])
			
		print("Game loaded successfully.")
	else:
		printerr("Failed to load save file.")
