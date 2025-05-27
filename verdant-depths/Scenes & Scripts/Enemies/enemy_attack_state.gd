extends NodeState

@export var animation_player: AnimatedSprite2D

@export var attack_animation := "Attack"
@export var post_attack_state_name := "EnemyAttackIdleState"

var parent: CharacterBody2D

func _on_enter():
	parent = get_parent().get_parent()
	animation_player.play("AttackDown")

func _on_physics_process(delta):
	parent.velocity = Vector2.ZERO

func _on_next_transitions():
	if not animation_player.is_playing():
		emit_signal("transition", post_attack_state_name)
