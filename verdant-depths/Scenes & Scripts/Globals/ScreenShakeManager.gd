extends Node

# Struct to store active shake info
class_name ShakeData
var strength = 0.0
var frequency = 1.0
var time_left = 0.0
var camera_influence_offset := Vector2.ZERO

# Active shakes
var active_shakes: Array[ShakeData] = []
var shake_offset := Vector2.ZERO
var original_camera: Camera2D = null

# Called externally to initiate a shake
func shake(strength := 5.0, duration := 0.3, frequency := 1.0):
	var shake_data = ShakeData.new()
	shake_data.strength = strength
	shake_data.frequency = frequency
	shake_data.time_left = duration
	active_shakes.append(shake_data)

# Internal update
func _process(delta):
	if original_camera == null:
		_find_camera()

	if original_camera == null or active_shakes.is_empty():
		return

	# Clear expired shakes
	active_shakes = active_shakes.filter(func(sd): return sd.time_left > 0)
	if active_shakes.is_empty():
		original_camera.offset = Vector2.ZERO
		return

	# Aggregate all active shake effects
	var total_offset = Vector2.ZERO
	for shake in active_shakes:
		var shake_strength = shake.strength * (shake.time_left / shake.time_left) # keep consistent decay if needed
		total_offset += Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		shake.time_left -= delta

	# Final offset (blend shakes)
	original_camera.offset = camera_influence_offset + (total_offset / active_shakes.size())

func _find_camera():
	# First camera found in current scene
	original_camera = get_tree().current_scene.get_node_or_null("Camera2D")
	if original_camera == null:
		original_camera = get_tree().current_scene.get_node_or_null("Player/Camera2D") # fallback path
