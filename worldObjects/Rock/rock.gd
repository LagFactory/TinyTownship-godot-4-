extends StaticBody3D

# --- NEW ITEM DATA ---
@export var item_drop: BaseItem 
@export var drop_amount: int = 3

@export var debris_scene: PackedScene 
@export var object_type: String = "rock"
@export var like_dist: float = 6.0
@export var any_dist: float = 2.0

var harvested = false

var interact_text: String = "Press E to harvest rock"
var label_offset: float = 1.1

func _ready() -> void:
	var terrain = get_tree().current_scene.find_child("Terrain3D", true, false)
	
	if terrain != null and terrain.data != null:
		var ground_height = terrain.data.get_height(global_position)
		
		if not is_nan(ground_height):
			global_position.y = ground_height

func harvest_action() -> void:
	if harvested == false:
		harvested = true 
		
		set_deferred("collision_layer", 0)
		set_deferred("collision_mask", 0)
		
		# --- NEW INVENTORY ADDITION ---
		if item_drop != null:
			Inventory.add_item(item_drop, drop_amount)
		else:
			printerr("Warning: No item_drop assigned to this rock!")
		
		if debris_scene != null:
			for i in range(20):
				var debris = debris_scene.instantiate()
				add_sibling(debris)
				
				var random_offset = Vector3(
					randf_range(-0.5, 0.5), 
					randf_range(0.0, 1.0), 
					randf_range(-0.5, 0.5)
				)
				debris.global_position = global_position + random_offset
				
				var random_direction = Vector3(
					randf_range(-1.0, 1.0),
					randf_range(0.5, 2.0), 
					randf_range(-1.0, 1.0)
				).normalized()
				
				var explosion_force = randf_range(4.0, 10.0)
				debris.apply_central_impulse(random_direction * explosion_force)
				
		queue_free()
