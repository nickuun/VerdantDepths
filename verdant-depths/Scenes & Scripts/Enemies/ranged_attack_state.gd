extends NodeState

@export var animated_sprite: AnimatedSprite2D
@export var projectile_scene: PackedScene
@export var cooldown_time := 0.8
@export var shoot_offset := 8.0  # distance from center to spawn bullet

var parent: CharacterBody2D
var player: Node2D
var timer := 0.0
var has_fired := false

func _on_enter():
	parent = get_parent().get_parent()
	player = get_tree().get_first_node_in_group("player")
	timer = cooldown_time
	has_fired = false

	parent.velocity = Vector2.ZERO

	if player:
		var dir = player.global_position - parent.global_position
		_play_shoot_animation(dir)

func _on_physics_process(delta):
	timer -= delta

	if not has_fired and not animated_sprite.is_playing():
		_shoot_projectile()
		has_fired = true

func _on_next_transitions():
	if timer <= 0:
		emit_signal("transition", "EnemyChaseState")

func _play_shoot_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		animated_sprite.play("AttackRight" if dir.x > 0 else "AttackLeft")
	else:
		animated_sprite.play("AttackDown" if dir.y > 0 else "AttackUp")

func _shoot_projectile():
	print("SHOOOT")
	if not projectile_scene or not player:
		return

	var bullet = projectile_scene.instantiate()
	var dir = (player.global_position - parent.global_position).normalized()

	bullet.global_position = parent.global_position + dir * shoot_offset
	bullet.direction = dir  # assumes your projectile scene uses this!
	get_tree().current_scene.add_child(bullet)
