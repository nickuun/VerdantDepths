extends NodeState

@export var attack_duration := 0.6
@export var animated_sprite: AnimatedSprite2D

@export var knockback_strength := 60.0
@export var knockback_duration := 0.2
@export var attack_duration_fallback := 0.6

var parent: CharacterBody2D
var player: Node2D
var post_attack_timer := 0.0
var did_knockback := false

var timer := 0.0

func _on_enter():
	parent = get_parent().get_parent()
	player = get_tree().get_first_node_in_group("player")
	did_knockback = false
	post_attack_timer = attack_duration_fallback  # safety fallback

	parent.velocity = Vector2.ZERO  # no movement during windup

	if player:
		var dir = (player.global_position - parent.global_position)
		_play_attack_animation(dir)

func _on_physics_process(delta):
	# Wait until animation is done
	if not did_knockback and not animated_sprite.is_playing():
		# Animation finished, apply knockback
		var dir = (player.global_position - parent.global_position).normalized()
		parent.velocity = -dir * knockback_strength
		did_knockback = true
		post_attack_timer = knockback_duration

	# Slide knockback
	if did_knockback:
		post_attack_timer -= delta
		parent.velocity = parent.velocity.move_toward(Vector2.ZERO, knockback_strength * delta)

func _on_next_transitions():
	if did_knockback and post_attack_timer <= 0:
		emit_signal("transition", "EnemyChaseState")

func _play_attack_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		animated_sprite.play("AttackRight" if dir.x > 0 else "AttackLeft")
	else:
		animated_sprite.play("AttackDown" if dir.y > 0 else "AttackUp")
