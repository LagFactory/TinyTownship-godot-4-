extends RigidBody3D
class_name BaseWorldObject

@export var item_data: BaseItem
@export var current_amount: int = 1

func _ready() -> void:
	if item_data == null:
		printerr("Warning: World object spawned without item data!")
		return
		
	_apply_item_visuals()

func _apply_item_visuals() -> void:
	# Because drop_mesh is a PackedScene, we instantiate it as a child node
	if item_data.drop_mesh != null:
		var visual_node = item_data.drop_mesh.instantiate()
		add_child(visual_node)
		
func interact() -> void:
	if item_data:
		print("Picked up ", current_amount, "x ", item_data.display_name)
		# Future step: Inventory.add_item(item_data, current_amount)
		queue_free()
