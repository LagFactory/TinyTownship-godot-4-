class_name TrainingCamp extends MilitaryBuilding

@export var training_speed_multiplier: float = 1.5
@export var active_training_queue: Array[String] = []

func _ready() -> void:
	building_type = "training_camp"
