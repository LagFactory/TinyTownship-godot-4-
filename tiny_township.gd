extends WorldEnvironment

# 1. Export variables so you can drag and drop your tree.tscn and rock.tscn in the Inspector
@export var tree_scene: PackedScene
@export var rock_scene: PackedScene

# Adjust how many of each you want to spawn
@export var tree_count: int = 50
@export var rock_count: int = 10

var spawned_objects_data = []

func _ready():
	var world_surface = %CSGBox3D
	
	var surface_size = world_surface.size
	var surface_pos = world_surface.global_position
	
	var min_x = surface_pos.x - (surface_size.x / 2.0)
	var max_x = surface_pos.x + (surface_size.x / 2.0)
	
	var min_z = surface_pos.z - (surface_size.z / 2.0)
	var max_z = surface_pos.z + (surface_size.z / 2.0)
	
	var top_y = surface_pos.y + (surface_size.y / 2.0)
	
	for i in range(tree_count):
		spawn_with_spacing(tree_scene, min_x, max_x, min_z, max_z, top_y)
		
	for i in range(rock_count):
		spawn_with_spacing(rock_scene, min_x, max_x, min_z, max_z, top_y)

# Notice we no longer pass the type or distances into this function
func spawn_with_spacing(scene: PackedScene, min_x: float, max_x: float, min_z: float, max_z: float, y_pos: float):
	if scene == null:
		return
		
	# 1. Create the instance immediately so we can read its built-in rules
	var instance = scene.instantiate()
	
	# 2. Extract the rules, using safe fallbacks in case we forgot to add them to a new object
	var obj_type = instance.get("object_type") if "object_type" in instance else "unknown"
	var like_dist = instance.get("like_dist") if "like_dist" in instance else 2.0
	var any_dist = instance.get("any_dist") if "any_dist" in instance else 2.0
		
	var max_attempts = 50
	var attempt = 0
	var successfully_placed = false
	var candidate_pos = Vector3.ZERO
	
	# 3. Search for a valid location using the extracted rules
	while attempt < max_attempts and not successfully_placed:
		candidate_pos = Vector3(randf_range(min_x, max_x), y_pos, randf_range(min_z, max_z))
		
		if position_is_valid(candidate_pos, obj_type, like_dist, any_dist):
			successfully_placed = true
			
		attempt += 1
		
	# 4. If we found a spot, add it to the world and track it
	if successfully_placed:
		add_child(instance)
		
		instance.global_position = candidate_pos
		instance.rotation_degrees.y = randf_range(0.0, 360.0)
		
		spawned_objects_data.append({"position": candidate_pos, "type": obj_type})
	else:
		# 5. If we failed to find a spot, destroy the unused instance to free memory
		instance.queue_free()
		print("Warning: Could not find a safe spot to spawn a ", obj_type)


func position_is_valid(target_pos: Vector3, new_object_type: String, like_dist: float, any_dist: float) -> bool:
	for existing_object in spawned_objects_data:
		var distance = target_pos.distance_to(existing_object["position"])
		
		if existing_object["type"] == new_object_type:
			if distance < like_dist:
				return false
		else:
			if distance < any_dist:
				return false
				
	return true
