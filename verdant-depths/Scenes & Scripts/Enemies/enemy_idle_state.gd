extends NodeState

@export var move_speed := 20.0
@export var idle_duration_range := Vector2(1.0, 2.5)
@export var walk_distance_range := Vector2(16.0, 64.0)
@export var detection_radius := 50.0  # detection range for switching to chase
@export var animated_sprite: AnimatedSprite2D

var timer := 0.0
var target_position := Vector2.ZERO
var parent: Node2D

func _on_enter():
	parent = get_parent().get_parent()
	timer = randf_range(idle_duration_range.x, idle_duration_range.y)
	# Random direction to walk a bit
	var angle = randf_range(0, TAU)
	target_position = parent.global_position + Vector2.RIGHT.rotated(angle) * randf_range(walk_distance_range.x, walk_distance_range.y)

func _on_physics_process(delta):
	
	var dir = (target_position - parent.global_position)
	if dir.length() > 4.0:
		parent.velocity = dir.normalized() * move_speed
	else:
		parent.velocity = Vector2.ZERO

	timer -= delta
	update_animation(parent.velocity)

func _on_next_transitions():
	if timer <= 0:
		emit_signal("transition", "EnemyIdleState")  # restart idle to pick new direction

	var player = get_tree().get_first_node_in_group("player")
	if player and parent.global_position.distance_to(player.global_position) < detection_radius:
		emit_signal("transition", "EnemyChaseState")

func update_animation(velocity: Vector2) -> void:
	if velocity.length() < 5:
		animated_sprite.play("Idle")  # play idle when not moving
		return

	var is_running = velocity.length() > 60  # tweak this threshold

	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			animated_sprite.play("WalkRight")
		else:
			animated_sprite.play("WalkLeft")
	else:
		if velocity.y > 0:
			animated_sprite.play("WalkDown")
		else:
			animated_sprite.play("WalkUp")
