extends CharacterBody2D

@export var max_health := 30
@onready var animated_sprite := $AnimatedSprite2D

var health := 0
var is_hit := false

func _ready():
	randomize()
	health = max_health

func _physics_process(delta):
	move_and_slide()

func take_damage(amount: int, source: Node) -> void:
	print("my health is: ", health)
	#if is_hit:
		#return

	health -= amount
	is_hit = true

	FloatingTextManager.show(
		str(amount),
		global_position + Vector2(0, -20)
	)

	ScreenShakeManager.shake(0.4, 0.2)

	# Flip toward impact
	var dir = (animated_sprite.global_position - source.global_position).normalized()
	animated_sprite.flip_h = dir.x < 0

	# Animate hit
	animated_sprite.speed_scale = randf_range(0.8, 1.2)
	animated_sprite.play("Hurt")

	await animated_sprite.animation_finished
	animated_sprite.speed_scale = 1.0

	if health <= 0:
		die()
	else:
		is_hit = false

func die():
	# You can expand this: play death anim, spawn loot, etc.
	queue_free()
	print("HERE DIES ME")	
