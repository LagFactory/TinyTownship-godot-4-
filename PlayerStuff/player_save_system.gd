extends Node

# This holds the reference to your physical 3D player in the level
var player_node: CharacterBody3D

func _ready() -> void:
	SaveManager.register_saveable("player", self)

func register_player(node: CharacterBody3D) -> void:
	player_node = node
	print("Player registered to PlayerManager.")

func pack_save_data() -> Dictionary:
	var data: Dictionary = {}
	
	# Only save position if the player actually exists in the scene
	if is_instance_valid(player_node):
		data["pos_x"] = player_node.global_position.x
		data["pos_y"] = player_node.global_position.y
		data["pos_z"] = player_node.global_position.z
		
		# Save the Y rotation so they face the same way when loading
		data["rot_y"] = player_node.rotation.y
		
	return data

func unpack_save_data(data: Dictionary) -> void:
	if is_instance_valid(player_node):
		# Check if the save file contains position data before applying it
		if data.has("pos_x") and data.has("pos_y") and data.has("pos_z"):
			var saved_position = Vector3(data["pos_x"], data["pos_y"], data["pos_z"])
			player_node.global_position = saved_position
			
		if data.has("rot_y"):
			player_node.rotation.y = data["rot_y"]
			
		print("Player position loaded.")
