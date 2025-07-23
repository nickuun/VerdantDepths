extends NodeState

@export var animation_player: AnimationPlayer
@export var hurtbox: Area2D

@export var attack_animation := "Attack"
@export var post_attack_state_name := "EnemyAttackIdleState"

var parent: CharacterBody2D

func _on_enter():
	parent = get_parent().get_parent()
	animation_player.play(attack_animation)
	#if hurtbox:
		#hurtbox.disabled = false  # enable the hitbox only during attack
#
#func _on_exit():
	#if hurtbox:
		#hurtbox.disabled = true  # always disable when leaving the state

func _on_physics_process(delta):
	parent.velocity = Vector2.ZERO

func _on_next_transitions():
	if not animation_player.is_playing():
		emit_signal("transition", post_attack_state_name)
