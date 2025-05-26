extends NodeState

@export var dash_distance := 90.0
@export var dash_duration := 0.4  # in seconds
@export var animated_sprite: AnimatedSprite2D

var parent: CharacterBody2D
var player: Node2D

var dash_dir := Vector2.ZERO
var dash_timer := 0.0
var origin_position := Vector2.ZERO
var dash_target := Vector2.ZERO

func _on_enter():
	parent = get_parent().get_parent()
	player = get_tree().get_first_node_in_group("player")

	dash_timer = 0.0
	origin_position = parent.global_position

	if player:
		dash_dir = (player.global_position - parent.global_position).normalized()
	else:
		dash_dir = Vector2.RIGHT

	dash_target = origin_position + dash_dir * dash_distance
	_play_charge_animation(dash_dir)

func _physics_process(delta):
	dash_timer += delta
	var t := dash_timer / dash_duration
	t = clamp(t, 0.0, 1.0)

	# Smooth in-out easing (Slow > Fast > Slow)
	var eased := sin(t * PI)

	# Interpolate position manually
	var next_pos := origin_position.lerp(dash_target, eased)
	if parent:
		var velocity = (next_pos - parent.global_position) / delta
		parent.velocity = velocity

func _on_next_transitions():
	if dash_timer >= dash_duration:
		emit_signal("transition", "EnemyChaseState")

func _play_charge_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		animated_sprite.play("RunRight" if dir.x > 0 else "RunLeft")
	else:
		animated_sprite.play("RunDown" if dir.y > 0 else "RunUp")
