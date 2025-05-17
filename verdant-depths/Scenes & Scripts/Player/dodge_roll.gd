extends NodeState

@export var player: Player
@export var aniSprite: AnimatedSprite2D
@export var dodge_speed: float = 250.0
@export var dodge_duration: float = 0.375
@export var cooldown: float = 1.6

var dodge_direction := Vector2.ZERO
var elapsed_time := 0.0
var easing_curve := Curve.new()

func _ready():
	# Ease-in and out curve
	easing_curve.add_point(Vector2(0, 0))
	easing_curve.add_point(Vector2(0.5, 1))
	easing_curve.add_point(Vector2(1, 0))

func _on_enter() -> void:
	print("Dodgeroll entered")

	elapsed_time = 0.0
	dodge_direction = GameInputEvents.movement_input().normalized()

	if dodge_direction == Vector2.ZERO:
		# Default dodge direction if standing still
		dodge_direction = Vector2.DOWN

	# Optionally: play dodge animation
	#aniSprite.play("dodge")  # Assuming you create one

func _on_process(_delta: float) -> void:
	# You can add visual effects, trail, i-frames, etc. here
	pass

func _on_physics_process(delta: float) -> void:
	elapsed_time += delta

	var t = elapsed_time / dodge_duration
	if t >= 1.0:
		transition.emit("ActionIdle")
		return

	var eased_t = easing_curve.sample(t)
	var motion = dodge_direction * dodge_speed * eased_t * delta
	player.global_position += motion

func _on_next_transitions() -> void:
	# Nothing to check — let it roll until done
	pass

func _on_exit() -> void:
	aniSprite.stop()
	CooldownTracker.start_cooldown(cooldown)
