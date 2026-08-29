extends Resource
# Registering the class name makes it appear in the Godot node/resource creation menu
class_name BaseItem

# Basic identification
@export var id: String = "base_item"
@export var display_name: String = "Unknown Item"
@export_multiline var description: String = ""

# Visuals
@export var icon: Texture2D # For the UI inventory menu
@export var drop_mesh: PackedScene # The 3D model to spawn when dropped

# Stacking rules
@export var is_stackable: bool = true
@export var max_stack_size: int = 99

# You can add a function here that all items share, like being inspected
func get_inspection_text() -> String:
	return display_name + ": " + description
