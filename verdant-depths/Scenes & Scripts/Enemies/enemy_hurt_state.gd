extends NodeState

@export var animation_player: AnimationPlayer
@export var animated_sprite: AnimatedSprite2D
@export var hurt_duration := 0.1

var parent: CharacterBody2D
var timer := 0.0
var knockback := Vector2.ZERO

func _on_enter():
	parent = get_parent().get_parent()

	# Set up knockback and timing
	knockback = parent.knockback_vector
	timer = hurt_duration
	parent.velocity = Vector2.ZERO

	# Animate sprite manually
	animated_sprite.play("Hurt")
	animated_sprite.speed_scale = 1.0
	if not animated_sprite.is_connected("animation_finished", Callable(self, "_on_hurt_animation_finished")):
		animated_sprite.connect("animation_finished", Callable(self, "_on_hurt_animation_finished"), CONNECT_ONE_SHOT)

	animated_sprite.frame = 0

	# Optional: Reset animation player or stop it if it's not used here
	if animation_player.is_playing():
		animation_player.stop()


func _on_physics_process(delta):
	timer -= delta
	parent.velocity = knockback
	parent.move_and_slide()
	knockback = knockback.move_toward(Vector2.ZERO, 800 * delta)

func _on_next_transitions():
	var is_anim_finished = animated_sprite.frame >= animated_sprite.sprite_frames.get_frame_count(animated_sprite.animation) - 1

	if timer <= 0 and is_anim_finished:
		animated_sprite.flip_h = false
		if parent.health <= 0:
			emit_signal("transition", "DeathState")
		else:
			emit_signal("transition", "EnemyChaseState")


func _on_hurt_animation_finished():
	if parent.health <= 0:
		emit_signal("transition", "DeathState")
	else:
		emit_signal("transition", "EnemyChaseState")
