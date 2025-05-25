extends Node2D

@export var charge_time := 1.5
@export var min_range := 10.0
@export var max_range := 150.0
@export var max_spread_deg := 45.0

@export var line_left: Sprite2D
@export var line_right: Sprite2D

var is_charging := false
var charge_start_time := 0.0

func _process(delta: float) -> void:
	# Always rotate gun toward mouse
	look_at(get_global_mouse_position())

	# Only update charge visuals when charging
	if is_charging:
		var charge_progress = clamp((Time.get_ticks_msec() - charge_start_time) / (charge_time * 1000.0), 0.0, 1.0)
		update_lines(charge_progress)

func start_charging():
	is_charging = true
	charge_start_time = Time.get_ticks_msec()
	update_lines(0)

func stop_charging_and_fire():
	is_charging = false
	var charge_progress = clamp((Time.get_ticks_msec() - charge_start_time) / (charge_time * 1000.0), 0.0, 1.0)

	var range = lerp(min_range, max_range, charge_progress)
	var spread = lerp(max_spread_deg, 0.0, charge_progress)
	var angle_offset = deg_to_rad(randf_range(-spread, spread))
	var direction = Vector2.RIGHT.rotated(rotation + angle_offset)

	fire_projectile(global_position, direction.normalized(), range)

	line_left.visible = false
	line_right.visible = false

func update_lines(progress: float):
	var spread = lerp(max_spread_deg, 0.0, progress)
	var range = lerp(min_range, max_range, progress)

	# Update visibility
	line_left.visible = true
	line_right.visible = true

	# Scale the line sprites to represent distance
	line_left.scale.x = range / line_left.texture.get_width()
	line_right.scale.x = range / line_right.texture.get_width()

	# Rotate sprites outward by spread
	line_left.rotation = deg_to_rad(-spread)
	line_right.rotation = deg_to_rad(spread)

func fire_projectile(position: Vector2, direction: Vector2, range: float):
	print("FIRING PROJECTILE with range:", range)
	# Your projectile logic here
