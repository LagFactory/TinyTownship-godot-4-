class_name Dorm extends ResidentialBuilding

@export var shift_rotation_active: bool = false

func _ready() -> void:
	max_occupants = 16 # Dorms hold bulk workers
	building_type = "dorm"
