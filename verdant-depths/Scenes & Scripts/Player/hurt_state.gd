extends NodeState

@export var player: Player
@export var animated_sprite: AnimatedSprite2D
@export var hurt_duration := 0.2
@export var knockback_strength := 20000.0
var source_position := Vector2.ZERO
var knockback_duration := 1.1
var knockback_elapsed := 0.0

var start_position := Vector2.ZERO
var end_position := Vector2.ZERO
var arc_height := 32.0  # Bounce height!
var in_knockback := false

var timer := 0.0
var knockback_velocity := Vector2.ZERO

func set_source_position(pos: Vector2) -> void:
	source_position = pos

func _on_enter() -> void:
	animated_sprite.play("hurt")
	player.velocity = Vector2.ZERO
	#player.set_collision_layer_value(0, false)
	start_position = player.global_position

	var direction = (player.global_position - source_position).normalized()
	direction = (direction + Vector2(randf() * 0.4 - 0.2, randf() * 0.4 - 0.2)).normalized()

	var knockback_distance = 64  # Or tweak as needed
	end_position = start_position + direction * knockback_distance

	# Freeze everything for emphasis
	get_tree().paused = true
	await get_tree().create_timer(0.1, true).timeout
	get_tree().paused = false

	# Start knockback motion
	in_knockback = true
	knockback_elapsed = 0.0

func _on_physics_process(delta: float) -> void:
	if in_knockback:
		knockback_elapsed += delta
		var t = clamp(knockback_elapsed / knockback_duration, 0.0, 1.0)
		var height = -4 * arc_height * t * (t - 1.0)  # Parabola formula

		var flat_pos = start_position.lerp(end_position, t)
		player.global_position = flat_pos + Vector2(0, -height)

		if t >= 1.0:
			in_knockback = false
			#player.set_collision_layer_value(0, true)
			transition.emit("ActionMove")  # or Idle

func _on_exit() -> void:
	player.velocity = Vector2.ZERO
	player.is_hurt = false
