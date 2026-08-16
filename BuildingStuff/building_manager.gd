extends Node


var available_buildings: Array[BuildingData] = []
var current_index: int = 0

func _ready() -> void:
	# Start the scan as soon as the game boots
	scan_for_buildings("res://BuildingStuff/buildingClasses")

# A recursive function that searches folders and subfolders
func scan_for_buildings(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not file_name.begins_with("."): # Ignore hidden files
				var full_path = path + "/" + file_name
				
				if dir.current_is_dir():
					# If it's a folder, run this function again inside that folder
					scan_for_buildings(full_path) 
				else:
					# Godot adds .remap to resource files when you export the game.
					# Checking for both ensures this works in the editor AND the final build.
					if file_name.ends_with(".tres") or file_name.ends_with(".tres.remap"):
						var clean_path = full_path.replace(".remap", "")
						var resource = ResourceLoader.load(clean_path)
						
						# Verify it is BuildingData and is unlocked
						if resource is BuildingData and resource.is_unlocked:
							available_buildings.append(resource)
							print("Unlocked building loaded: ", resource.building_name)
							
			file_name = dir.get_next()
		dir.list_dir_end()

# Helper function to get the currently selected data
func get_active_building() -> BuildingData:
	if available_buildings.size() > 0:
		return available_buildings[current_index]
	return null

# Helper function to cycle through the array
func cycle_next_building() -> void:
	if available_buildings.size() > 0:
		var old_scene = get_active_building().rtc_scene.resource_path.get_file()
		
		# Move to the next index, and wrap around to 0 if we hit the end
		current_index = (current_index + 1) % available_buildings.size()
		
		var new_scene = get_active_building().rtc_scene.resource_path.get_file()
		
		print("Old Scene: ", old_scene)
		print("New Scene: ", new_scene)
		print("Ready to build: ", get_active_building().building_name)
