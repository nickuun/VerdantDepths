extends Node2D

@export var max_offset: float = 25.0
@export var deadzone_radius: float = 1.0
@export var smooth_speed: float = 3.0

var target_offset: Vector2 = Vector2.ZERO
var current_offset: Vector2 = Vector2.ZERO

func _process(delta):
	var player = get_parent()
	if not player:
		return

	var mouse = get_viewport().get_mouse_position()
	var screen_center = get_viewport().get_camera_2d().get_screen_center_position()
	var screen_size = get_viewport().get_visible_rect().size

	# Normalize direction: -1 to +1 in both axes
	var screen_dir = (mouse - screen_center) / (screen_size / 2)
	screen_dir = screen_dir.limit_length(1.0)


	# Optional easing (e.g. square it for subtlety)
	var eased_dir = Vector2(
		screen_dir.x * abs(screen_dir.x),
		screen_dir.y * abs(screen_dir.y)
	)

	target_offset = eased_dir * max_offset
	current_offset = current_offset.lerp(target_offset, 1.0 - pow(0.001, delta * smooth_speed))

	global_position = player.global_position + current_offset
	ScreenShakeManager.camera_influence_offset = current_offset
