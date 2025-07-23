extends NodeState

@export var animated_sprite: AnimatedSprite2D
@export var cooldown_duration := 1.5
@export var reengage_distance := 80.0
@export var chase_state_name := "EnemyChaseState"
@export var idle_anim := "Idle"

var timer := 0.0
var parent: CharacterBody2D
var player: Node2D

func _on_enter():
	parent = get_parent().get_parent()
	player = get_tree().get_first_node_in_group("player")
	timer = cooldown_duration
	animated_sprite.play(idle_anim)

func _on_physics_process(delta):
	timer -= delta
	parent.velocity = Vector2.ZERO

func _on_next_transitions():
	if timer <= 0 and player:
		var dist = parent.global_position.distance_to(player.global_position)
		if dist < reengage_distance:
			emit_signal("transition", chase_state_name)
		else:
			emit_signal("transition", "EnemyIdleState")
