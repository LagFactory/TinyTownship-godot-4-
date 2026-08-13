extends CharacterBody3D

# --- CAMERA SETTINGS ---
@export var mouse_sensitivity_x: float = 0.5
@export var mouse_sensitivity_y: float = 0.25
@export var camera_pitch_min: float = -60.0
@export var camera_pitch_max: float = 80.0

# --- MOVEMENT SETTINGS ---
@export var walk_speed: float = 5.5
@export var jump_velocity: float = 10.0
@export var gravity: float = 20.0

# --- UI SETTINGS ---
@export var default_label_offset: float = 1.5
@export var label_height_offset: float = 0.5

@onready var interaction_detector: RayCast3D = %interaction_detector
@onready var dynamic_label: Label3D = %interact_label

var current_target: Node3D = null

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	interaction_detector.add_exception(self)
	dynamic_label.visible = false

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity_x
		%PlayerViewCam.rotation_degrees.x -= event.relative.y * mouse_sensitivity_y
		%PlayerViewCam.rotation_degrees.x = clamp(%PlayerViewCam.rotation_degrees.x, camera_pitch_min, camera_pitch_max)
	elif event.is_action_pressed("interact"):
		# Verify we are looking at something, and that it has the harvest function
		if current_target != null and current_target.has_method("harvest_action"):
			current_target.harvest_action()

func _physics_process(delta):
	# --- 1. MOVEMENT LOGIC ---
	var input_direction_2D = Input.get_vector(
		"move_left","move_right","move_forward","move_back"
	)
	
	var input_direction_3D = Vector3(
		input_direction_2D.x, 0.0, input_direction_2D.y
	)
	
	var direction = transform.basis * input_direction_3D
	
	velocity.x = direction.x * walk_speed
	velocity.z = direction.z * walk_speed
	velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0.0
		
	move_and_slide()
	
	# --- 2. INTERACTION & LABEL LOGIC ---
	var new_target = null
	
	if interaction_detector.is_colliding():
		var collider = interaction_detector.get_collider()
		if collider != null:
			var root_instance = collider.get_parent()
			
			if root_instance != null:
				# If it is a harvestable object, assign it to new_target
				if root_instance.has_method("harvest_action"):
					new_target = root_instance 
					
					# Update the label text if the object has it
					if "interact_text" in new_target:
						dynamic_label.text = new_target.interact_text
					
					# Check for a custom offset, use the exported default if missing
					var offset_distance = default_label_offset
					if "label_offset" in new_target:
						offset_distance = new_target.label_offset
					
					# Calculate positioning
					var target_pos = new_target.global_position
					var cam_pos = %PlayerViewCam.global_position
					var direction_to_cam = target_pos.direction_to(cam_pos)
					
					# Push label toward camera using our dynamic distance, and adjust height
					dynamic_label.global_position = target_pos + (direction_to_cam * offset_distance)
					dynamic_label.global_position.y += label_height_offset
					
					# Show the label
					dynamic_label.visible = true
				
	# 3. Handle looking away
	if new_target == null:
		# If we hit nothing, or a non-interactive object, hide the label
		dynamic_label.visible = false
			
	# 4. Save the target for the input function to use
	current_target = new_target
