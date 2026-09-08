extends RigidBody3D
class_name BaseWorldObject

@export var item_data: BaseItem
@export_range(1, 9999, 1) var current_amount: int = 1
@export var pickup_radius: float = 0.35

# Prevents double-picking up an item before queue_free() finishes
var _is_being_picked_up: bool = false

func get_interact_text() -> String:
	return "Press E to pick up " + (item_data.display_name if item_data else "item")

func _ready() -> void:
	_ensure_collision()
	if item_data != null:
		_apply_item_visuals()

# Use this function when spawning drops from enemies or the player's inventory
func initialize(data: BaseItem, amount: int = 1) -> void:
	if data == null or amount <= 0:
		return
	item_data = data
	current_amount = amount
	_ensure_collision()
	_apply_item_visuals()

func _ensure_collision() -> void:
	for child in get_children():
		if child is CollisionShape3D:
			return
	var collision := CollisionShape3D.new()
	var shape := SphereShape3D.new()
	shape.radius = maxf(pickup_radius, 0.1)
	collision.shape = shape
	collision.set_meta("generated_pickup_collision", true)
	add_child(collision)

func _apply_item_visuals() -> void:
	# Clear existing visuals if recycling/re-initializing the object
	for child in get_children():
		if child is MeshInstance3D or child.has_meta("is_drop_visual"):
			child.queue_free()

	if item_data != null and item_data.drop_mesh != null:
		var visual_node = item_data.drop_mesh.instantiate()
		visual_node.set_meta("is_drop_visual", true) # Tag it for easy identification
		add_child(visual_node)
		
func interact() -> bool:
	if _is_being_picked_up:
		return false
		
	if item_data == null or not item_data.validate():
		return false
	_is_being_picked_up = true
	if not Inventory.add_item(item_data, current_amount):
		_is_being_picked_up = false
		return false
	queue_free()
	return true
