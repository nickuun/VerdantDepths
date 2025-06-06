extends NodeState

@export var animation_player: AnimationPlayer
@export var animated_sprite: AnimatedSprite2D
@export var hurt_duration := 0.1

var parent: CharacterBody2D
var timer := 0.0
var knockback := Vector2.ZERO

func _on_enter():
	animation_player.play("Hurt")
	#print("HURST STATE ENTER")
	parent = get_parent().get_parent()
	knockback = parent.knockback_vector
	timer = hurt_duration
	parent.velocity = Vector2.ZERO
	animation_player.speed_scale = 1.0
	#animation_player.speed_scale = randf_range(0.8, 1.2)

func _on_physics_process(delta):
	timer -= delta
	parent.velocity = knockback
	parent.move_and_slide()
	knockback = knockback.move_toward(Vector2.ZERO, 800 * delta)

func _on_next_transitions():
	if timer <= 0 and !animation_player.is_playing():
		animated_sprite.flip_h = false
		if parent.health <= 0:
			emit_signal("transition", "DeathState")  # optional if you want separate death state
		else:
			emit_signal("transition", "EnemyChaseState")  # or back to idle etc.
