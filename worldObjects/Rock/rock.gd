extends StaticBody3D
# This allows you to drag and drop your rock_debris.tscn into the Inspector
@export var debris_scene: PackedScene 
@export var object_type: String = "rock"
@export var like_dist: float = 6.0
@export var any_dist: float = 2.0

var harvested = false

var interact_text: String = "Press E to harvest rock"
var label_offset: = 1.1

func harvest_action() -> void:
	if harvested == false:
		harvested = true 
		
		set_deferred("collision_layer", 0)
		set_deferred("collision_mask", 0)
		
		# 1. Check if a debris scene is assigned to prevent crashes
		if debris_scene != null:
			Inventory.add_resource("stone", 3)
			# 2. Loop to spawn pieces of debris 
			for i in range(20):
				var debris = debris_scene.instantiate()
				
				# 3. Add the debris to the main game world
				# We add it to the current_scene so it does not get deleted when the main rock is destroyed
				add_sibling(debris)
				
				# 4. Set the starting position to the main rock's position
				# We add a slight random offset so they do not spawn perfectly inside each other
				var random_offset = Vector3(
					randf_range(-0.5, 0.5), 
					randf_range(0.0, 1.0), 
					randf_range(-0.5, 0.5)
				)
				debris.global_position = global_position + random_offset
				
				# 5. Calculate a random outward direction
				var random_direction = Vector3(
					randf_range(-1.0, 1.0),
					randf_range(0.5, 2.0), # Favor upwards momentum
					randf_range(-1.0, 1.0)
				).normalized()
				
				# 6. Apply physical force to the debris
				var explosion_force = randf_range(4.0, 10.0)
				debris.apply_central_impulse(random_direction * explosion_force)
				
		# 7. Delete the original solid rock
		queue_free()
