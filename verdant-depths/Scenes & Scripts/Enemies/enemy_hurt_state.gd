extends NodeState

@export var animation_player: AnimationPlayer
@export var hurt_duration := 0.3

var parent: CharacterBody2D
var timer := 0.0

func _on_enter():
	parent = get_parent().get_parent()
	timer = hurt_duration
	parent.velocity = Vector2.ZERO

	animation_player.speed_scale = randf_range(0.8, 1.2)
	animation_player.play("Hurt")

func _on_physics_process(delta):
	timer -= delta

func _on_next_transitions():
	if timer <= 0:
		if parent.health <= 0:
			emit_signal("transition", "DeathState")  # optional if you want separate death state
		else:
			emit_signal("transition", "EnemyChaseState")  # or back to idle etc.
