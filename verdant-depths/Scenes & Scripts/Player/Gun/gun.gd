extends Node2D

@export var bullet_scene: PackedScene

@export var charge_time := 1.5
@export var min_range := 10.0
@export var max_range := 100.0
@export var max_spread_deg := 45.0

@export var line_left: Sprite2D
@export var line_right: Sprite2D

@export var jitter_max_offset := 1.5  # Max pixels of jitter when fully charged
@export var jitter_ramp_up_time := 1.2  # Time (in seconds) after full charge before full jitter

var is_charging := false
var charge_start_time := 0.0



func _process(delta: float) -> void:
	# Always rotate gun toward mouse
	look_at(get_global_mouse_position())

	# Only update charge visuals when charging
	if is_charging:
		var charge_progress = clamp((Time.get_ticks_msec() - charge_start_time) / (charge_time * 1000.0), 0.0, 1.0)
		update_lines(charge_progress)
		if charge_progress >= 1.0:
			var overcharge_time = ((Time.get_ticks_msec() - charge_start_time) / 1000.0) - charge_time
			var jitter_progress = clamp(overcharge_time / jitter_ramp_up_time, 0.0, 1.0)
			apply_jitter(jitter_progress)
		else:
			reset_jitter()

func start_charging():
	is_charging = true
	charge_start_time = Time.get_ticks_msec()
	update_lines(0)

func stop_charging_and_fire():
	is_charging = false
	var charge_progress = clamp((Time.get_ticks_msec() - charge_start_time) / (charge_time * 1000.0), 0.0, 1.0)

	var range = lerp(min_range, max_range, charge_progress)
	var accuracy = charge_progress  # 0.0 to 1.0
	var spread = max_spread_deg * (1.0 - accuracy)
	var angle_offset = deg_to_rad(randf_range(-spread, spread))
	var direction = Vector2.RIGHT.rotated(rotation + angle_offset)

	fire_projectile(global_position, direction.normalized(), charge_progress)

	line_left.visible = false
	line_right.visible = false

func update_lines(progress: float):
	var spread = lerp(max_spread_deg, 0.0, progress)
	var range = lerp(min_range, max_range, progress)

	# Update visibility
	line_left.visible = true
	line_right.visible = true

	# Set region rect size
	var region_left = line_left.region_rect
	var region_right = line_right.region_rect

	region_left.size.x = range
	region_right.size.x = range

	line_left.region_rect = region_left
	line_right.region_rect = region_right

	# Rotate sprites outward by spread
	line_left.rotation = deg_to_rad(-spread)
	line_right.rotation = deg_to_rad(spread)

func apply_jitter(jitter_progress: float):
	var jitter_amount = jitter_max_offset * jitter_progress

	# Random small offset per frame
	line_left.position = Vector2(randf_range(-jitter_amount, jitter_amount), randf_range(-jitter_amount, jitter_amount))
	line_right.position = Vector2(randf_range(-jitter_amount, jitter_amount), randf_range(-jitter_amount, jitter_amount))

func reset_jitter():
	line_left.position = Vector2.ZERO
	line_right.position = Vector2.ZERO

func fire_projectile(position: Vector2, direction: Vector2, charge_progress: float):
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		get_parent().get_parent().add_child(bullet)
		bullet.global_position = position
		bullet.rotation = direction.angle()
		bullet.direction = direction
		
		bullet.charge_progress = charge_progress
		bullet.initialize()
	else:
		print("Bullet scene not assigned!")
