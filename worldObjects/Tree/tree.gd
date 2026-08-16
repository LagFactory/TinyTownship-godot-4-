extends StaticBody3D

@onready var tree_mesh = $TreeMesh 
@onready var pivot_point = $pivot_point

@export var object_type: String = "tree"
@export var like_dist: float = 4.0
@export var any_dist: float = 2.0

var harvested = false
var interact_text: String = "Press E to harvest Tree"
var label_offset: = 0.5

func harvest_action():
	if harvested == false:
		# 1. Immediately mark as harvested so it cannot be clicked again
		harvested = true 
		Inventory.add_resource("wood", 3)
		# 2. Safely disable collision so the raycast ignores it while falling
		set_deferred("collision_layer", 0)
		set_deferred("collision_mask", 0)
		
		# 3. Calculate the math for the exact final position (same as before)
		var rad_x = deg_to_rad(90)
		var rad_y = deg_to_rad(90)
		
		var pivot_transform = Transform3D()
		pivot_transform = pivot_transform.translated(pivot_point.position)
		pivot_transform = pivot_transform.rotated(Vector3.RIGHT, rad_x)
		pivot_transform = pivot_transform.rotated(Vector3.UP, rad_y)
		pivot_transform = pivot_transform.translated(-pivot_point.position)
		
		# This is the final resting position we want to reach
		var target_transform = pivot_transform * tree_mesh.transform
		
		# 4. Create a Tween to animate the movement over 1.0 second
		var tween = create_tween()
		
		# Optional: This makes the tree start falling slowly and speed up as it hits the ground
		tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN) 
		
		# Animate the tree_mesh's "transform" property to the target_transform over 1.0 second
		tween.tween_property(tree_mesh, "transform", target_transform, 1.0)
		
		# 5. Start the timer to delete the tree
		%despawn_timer.start()
		


func _on_despawn_timer_timeout() :
	queue_free()
