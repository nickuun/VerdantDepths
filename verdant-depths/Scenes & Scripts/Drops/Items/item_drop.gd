extends Area2D

@export var arc_height := randf_range(24, 48)
@export var lifetime := 8.0
@export var time_to_land := 0.4 + randf_range(-0.05, 0.05)

var start_position := Vector2.ZERO
var target_position := Vector2.ZERO
var elapsed := 0.0
var landed := false

func launch_to(target: Vector2):
	start_position = global_position
	target_position = target
	elapsed = 0.0
	landed = false
	$CollisionShape2D.set_deferred("disabled", true)

func _process(delta):
	if not landed:
		elapsed += delta
		var t = clamp(elapsed / time_to_land, 0.0, 1.0)
		var height = -4 * arc_height * t * (t - 1.0)  # Simple parabola
		global_position = start_position.lerp(target_position, t) + Vector2(0, -height)

		if t >= 1.0:
			landed = true
			$CollisionShape2D.set_deferred("disabled", false)
			# Optional: play landing sound/particles
	else:
		lifetime -= delta
		if lifetime <= 0.0:
			queue_free()

func _on_body_entered(body):
	if body.name == "Player":  # Replace with actual player check
		# Add to inventory, score, ammo, etc.
		queue_free()
