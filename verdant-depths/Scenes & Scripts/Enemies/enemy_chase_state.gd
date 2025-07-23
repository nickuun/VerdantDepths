extends NodeState

@export var chase_speed := 30.0
@export var lose_radius := 60.0
@export var attack_range := 20.0
@export var attack_state_name := "EnemyAttackState"

@export var animated_sprite: AnimatedSprite2D

var parent: CharacterBody2D
@export var hurtbox: Area2D
var player: Node2D

func _on_enter():
	if hurtbox:
		hurtbox.get_child(0).disabled = true
	parent = get_parent().get_parent()
	player = get_tree().get_first_node_in_group("player")

func _on_physics_process(delta):
	if not player:
		parent.velocity = Vector2.ZERO
		return

	var dir = (player.global_position - parent.global_position).normalized()
	parent.velocity = dir * chase_speed

	update_animation(parent.velocity)

func _on_next_transitions():
	if not player:
		return
	
	if player and parent.global_position.distance_to(player.global_position) < attack_range:
		emit_signal("transition", attack_state_name)

	if parent.global_position.distance_to(player.global_position) > lose_radius:
		emit_signal("transition", "EnemyIdleState")

func update_animation(velocity: Vector2) -> void:
	if velocity.length() < 1:
		animated_sprite.stop()
		return

	if abs(velocity.x) > abs(velocity.y):
		animated_sprite.play("RunRight" if velocity.x > 0 else "RunLeft")
	else:
		animated_sprite.play("RunDown" if velocity.y > 0 else "RunUp")
