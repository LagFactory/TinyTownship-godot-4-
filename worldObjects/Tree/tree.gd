extends StaticBody3D

@onready var tree_mesh = $TreeMesh 
@onready var pivot_point = $pivot_point

# --- NEW ITEM DATA ---
@export var item_drop: BaseItem
@export var drop_amount: int = 3

@export var object_type: String = "tree"
@export var like_dist: float = 4.0
@export var any_dist: float = 2.0

var harvested = false
var interact_text: String = "Press E to harvest Tree"
var label_offset: float = 0.5

func harvest_action():
	if harvested == false:
		harvested = true 
		
		# --- NEW INVENTORY ADDITION ---
		if item_drop != null:
			Inventory.add_item(item_drop, drop_amount)
		else:
			printerr("Warning: No item_drop assigned to this tree!")
			
		set_deferred("collision_layer", 0)
		set_deferred("collision_mask", 0)
		
		var rad_x = deg_to_rad(90)
		var rad_y = deg_to_rad(90)
		
		var pivot_transform = Transform3D()
		pivot_transform = pivot_transform.translated(pivot_point.position)
		pivot_transform = pivot_transform.rotated(Vector3.RIGHT, rad_x)
		pivot_transform = pivot_transform.rotated(Vector3.UP, rad_y)
		pivot_transform = pivot_transform.translated(-pivot_point.position)
		
		var target_transform = pivot_transform * tree_mesh.transform
		
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN) 
		tween.tween_property(tree_mesh, "transform", target_transform, 1.0)
		
		%despawn_timer.start()

func _on_despawn_timer_timeout():
	queue_free()
