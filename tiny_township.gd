extends WorldEnvironment

@export var tree_scene: PackedScene
@export var rock_scene: PackedScene

@export var tree_count: int = 500
@export var rock_count: int = 100

# 1. New variables to link your Terrain3D and define the spawn area size
@export var terrain: Terrain3D
@export var map_size: float = 1024.0 # Represents one default Terrain3D region

func _ready():
	# Safety check to ensure the terrain is connected
	if terrain == null or terrain.data == null:
		push_error("Terrain3D is missing or data is not initialized!")
		return
	
	# Calculate boundaries based on the map size centered at (0, 0, 0)
	var half_size = map_size / 2.0
	var min_x = -half_size
	var max_x = half_size
	var min_z = -half_size
	var max_z = half_size
	
	for i in range(tree_count):
		# We no longer pass y_pos here
		await spawn_with_spacing(tree_scene, min_x, max_x, min_z, max_z)
		
	for i in range(rock_count):
		await spawn_with_spacing(rock_scene, min_x, max_x, min_z, max_z)

func spawn_with_spacing(scene: PackedScene, min_x: float, max_x: float, min_z: float, max_z: float):
	if scene == null:
		return
		
	var instance = scene.instantiate()
	
	var obj_type = instance.get("object_type") if "object_type" in instance else "unknown"
	var like_dist = instance.get("like_dist") if "like_dist" in instance else 2.0
	var any_dist = instance.get("any_dist") if "any_dist" in instance else 2.0
		
	var max_attempts = 50
	var attempt = 0
	var successfully_placed = false
	var candidate_pos = Vector3.ZERO
	
	while attempt < max_attempts and not successfully_placed:
		# Pick a random X and Z coordinate
		var random_x = randf_range(min_x, max_x)
		var random_z = randf_range(min_z, max_z)
		
		# Ask Terrain3D for the exact height of the ground
		var ground_height = terrain.data.get_height(Vector3(random_x, 0, random_z))
		
	
		# If the height is Not a Number (e.g., outside a painted region), skip this spot
		if is_nan(ground_height):
			attempt += 1
			continue
			
		# Compile the final Vector3 with the safe height
		candidate_pos = Vector3(random_x, ground_height, random_z)
		
		if position_is_valid(candidate_pos, obj_type, like_dist, any_dist):
			successfully_placed = true
			
		attempt += 1
		
	if successfully_placed:
		add_child(instance)
		
		instance.global_position = candidate_pos
		instance.rotation_degrees.y = randf_range(0.0, 360.0)
		
		await get_tree().physics_frame
	else:
		instance.queue_free()
		print("Warning: Could not find a safe spot to spawn a ", obj_type)

func position_is_valid(target_pos: Vector3, new_object_type: String, like_dist: float, any_dist: float) -> bool:
	var space_state = get_viewport().get_world_3d().direct_space_state
	
	var sphere = SphereShape3D.new()
	sphere.radius = max(like_dist, any_dist) 
	
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = sphere
	query.transform = Transform3D(Basis(), target_pos)
	
	var hits = space_state.intersect_shape(query)
	
	for hit in hits:
		var collider = hit.collider
		
		var hit_type = "unknown"
		if "object_type" in collider:
			hit_type = collider.object_type
		elif collider.get_parent() != null and "object_type" in collider.get_parent():
			hit_type = collider.get_parent().object_type
			
		var distance = target_pos.distance_to(collider.global_position)
		
		if hit_type == new_object_type:
			if distance < like_dist:
				return false
		else:
			if distance < any_dist:
				return false
				
	return true
