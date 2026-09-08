extends RigidBody3D
class_name BaseWorldObject

@export var item_data: BaseItem
@export var current_amount: int = 1

# Prevents double-picking up an item before queue_free() finishes
var _is_being_picked_up: bool = false

func _ready() -> void:
	# Only apply visuals automatically if placed via the editor.
	# Dynamically spawned items will call initialize() directly.
	if item_data != null:
		_apply_item_visuals()

# Use this function when spawning drops from enemies or the player's inventory
func initialize(data: BaseItem, amount: int = 1) -> void:
	item_data = data
	current_amount = amount
	_apply_item_visuals()

func _apply_item_visuals() -> void:
	# Clear existing visuals if recycling/re-initializing the object
	for child in get_children():
		if child is MeshInstance3D or child.has_meta("is_drop_visual"):
			child.queue_free()

	if item_data != null and item_data.drop_mesh != null:
		var visual_node = item_data.drop_mesh.instantiate()
		visual_node.set_meta("is_drop_visual", true) # Tag it for easy identification
		add_child(visual_node)
		
		# IMPORTANT: Your drop_mesh PackedScene should idealy just be a MeshInstance3D.
		# The CollisionShape3D should either be baked into this BaseWorldObject scene, 
		# or you must generate one via code based on the mesh bounds right here.

func interact() -> void:
	if _is_being_picked_up:
		return
		
	if item_data:
		_is_being_picked_up = true
		print("Picked up ", current_amount, "x ", item_data.display_name)
		
		# Future step: bool success = Inventory.add_item(item_data, current_amount)
		# if success: queue_free() else: _is_being_picked_up = false
		queue_free()
