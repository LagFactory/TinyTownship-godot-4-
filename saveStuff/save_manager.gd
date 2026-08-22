extends Node

const SAVE_PATH = "user://saveStuff/save_game.sav"
const DEBUG_SAVE_PATH = "user://saveStuff/save_game.json"

@export var is_debug_mode: bool = true

var _saveables: Dictionary = {}

func register_saveable(save_key: String, node: Node) -> void:
	_saveables[save_key] = node

func save_game() -> void:
	var master_data: Dictionary = {}
	
	# Ask each registered saveable for its data
	for save_key in _saveables:
		master_data[save_key] = _saveables[save_key].pack_save_data()
	
	# Ensure the save folder exists
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("saveStuff"):
		dir.make_dir("saveStuff")
	
	# Save binary
	var bin_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if bin_file:
		bin_file.store_var(master_data) 
		bin_file.close()
	else:
		printerr("Failed to open binary save file for writing.")

	# Save JSON debug file
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
		
		# Give the data back to each registered saveable
		for save_key in master_data:
			if _saveables.has(save_key):
				_saveables[save_key].unpack_save_data(master_data[save_key])
			
		print("Game loaded successfully.")
	else:
		printerr("Failed to load save file.")
