extends NodeState

@export var wind_up_time := 0.5
@export var animation_player: AnimationPlayer
@export var attack_state_name := "EnemyAttackState"

var timer := 0.0
var parent: CharacterBody2D

func _on_enter():
	print("ENter")
	parent = get_parent().get_parent()
	timer = wind_up_time
	#animation_player.play("PreAttack")

func _on_physics_process(delta):
	parent.velocity = Vector2.ZERO
	timer -= delta

func _on_next_transitions():
	if timer <= 0:
		emit_signal("transition", attack_state_name)
