extends RigidBody3D


func _ready():
	%Timer.start()



func _on_timer_timeout() -> void:
	queue_free()
