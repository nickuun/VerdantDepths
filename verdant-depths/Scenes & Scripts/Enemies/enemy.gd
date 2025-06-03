extends CharacterBody2D

@export var max_health := 30
@onready var animated_sprite := $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var health := 0
var is_hit := false

func _ready():
	randomize()
	health = max_health

func _physics_process(delta):
	move_and_slide()

func take_damage(amount: int, source: Node) -> void:
	if health <= 0:
		return  # Already dead, do nothing

	health -= amount

	FloatingTextManager.show(str(amount), global_position + Vector2(0, -20))
	#ScreenShakeManager.shake(0.3, 0.2)
	ScreenShakeManager.shake(0.4, 0.2)

	animated_sprite.animation = "Hurt"
	animated_sprite.frame = 0
	animation_player.play("RESET")
	# Flip toward attacker
	var dir = (animated_sprite.global_position - source.global_position).normalized()
	animated_sprite.flip_h = dir.x < 0

	# Transition to hurt state
	var state_machine = $StateMachine
	if health <= 0:
		die()
	else:
		#animation_player.play("Hurt")
		state_machine.transition_to("EnemyHurtState")

func die():
	# You can expand this: play death anim, spawn loot, etc.
	queue_free()
	#animation_player.play("Death")
	print("HERE DIES ME")

func damage_player():
	print("")
