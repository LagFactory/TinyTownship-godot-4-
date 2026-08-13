extends WorldEnvironment

@export var tree_scene: PackedScene
@export var rock_scene: PackedScene

@export var tree_count: int = 50
@export var rock_count: int = 10

func _ready():
	var world_surface = %CSGBox3D
	
	var surface_size = world_surface.size
	var surface_pos = world_surface.global_position
	
	var min_x = surface_pos.x - (surface_size.x / 2.0)
	var max_x = surface_pos.x + (surface_size.x / 2.0)
	
	var min_z = surface_pos.z - (surface_size.z / 2.0)
	var max_z = surface_pos.z + (surface_size.z / 2.0)
	
	var top_y = surface_pos.y + (surface_size.y / 2.0)
	
	# We use 'await' here because the spawn function must pause to wait for physics updates
	for i in range(tree_count):
		await spawn_with_spacing(tree_scene, min_x, max_x, min_z, max_z, top_y)
		
	for i in range(rock_count):
		await spawn_with_spacing(rock_scene, min_x, max_x, min_z, max_z, top_y)

func spawn_with_spacing(scene: PackedScene, min_x: float, max_x: float, min_z: float, max_z: float, y_pos: float):
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
		candidate_pos = Vector3(randf_range(min_x, max_x), y_pos, randf_range(min_z, max_z))
		
		if position_is_valid(candidate_pos, obj_type, like_dist, any_dist):
			successfully_placed = true
			
		attempt += 1
		
	if successfully_placed:
		add_child(instance)
		
		instance.global_position = candidate_pos
		instance.rotation_degrees.y = randf_range(0.0, 360.0)
		
		# CRITICAL: Pause execution for one physics tick. 
		# This gives Godot time to register the new object's collision shape in the world.
		await get_tree().physics_frame
	else:
		instance.queue_free()
		print("Warning: Could not find a safe spot to spawn a ", obj_type)

func position_is_valid(target_pos: Vector3, new_object_type: String, like_dist: float, any_dist: float) -> bool:
	# 1. Access the physical space of the game world
	var space_state = get_viewport().get_world_3d().direct_space_state
	
	# 2. Create an invisible sphere to act as our scanner
	var sphere = SphereShape3D.new()
	sphere.radius = max(like_dist, any_dist) # Make it as big as our largest requirement
	
	# 3. Configure the scan parameters
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = sphere
	query.transform = Transform3D(Basis(), target_pos)
	
	# 4. Perform the scan! Returns an array of dictionaries for everything touched.
	var hits = space_state.intersect_shape(query)
	
	for hit in hits:
		var collider = hit.collider
		
		# Try to find the object_type variable. 
		# We check both the collider itself and its parent node just in case.
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
