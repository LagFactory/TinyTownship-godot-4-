extends RigidBody3D


func _ready():
	%Timer.start()



func _on_timer_timeout() -> void:
	if is_instance_valid(self) and not is_queued_for_deletion():
		queue_free()
