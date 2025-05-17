extends NodeState

@export var player: Player
@export var animatedSprite: AnimatedSprite2D
@export var hitComponentOffset: Node2D
@export var weaponSprite: AnimatedSprite2D

@export var attack_durations := [0.2, 0.2, 0.35]
@export var combo_input_window := 0.3
@export var combo_cooldown := 0.6
@export var movement_influence := 0.1
@export var lunge_distance := 30.0
@export var lunge_speed := 120.0

var current_attack := 0
var timer := 0.0
var awaiting_input := false
var attack_started := false
var easing_curve := Curve.new()
var lunge_direction := Vector2.ZERO
var attack_motion_time := 0.0

func _ready():
	easing_curve.add_point(Vector2(0, 0))
	easing_curve.add_point(Vector2(0.5, 0.3))
	easing_curve.add_point(Vector2(1, 1))

func _on_enter() -> void:
	current_attack = 0
	start_attack(current_attack)

func _on_exit() -> void:
	print("empty")
	weaponSprite.play("empty")
	player.velocity = Vector2.ZERO
	attack_started = false
	awaiting_input = false
	CooldownTracker.start_cooldown(combo_cooldown)

func start_attack(index: int) -> void:
	timer = 0.0
	attack_motion_time = 0.0
	awaiting_input = false
	attack_started = true

	var mouse_position = player.get_global_mouse_position()
	hitComponentOffset.look_at(mouse_position)
	hitComponentOffset.rotation += deg_to_rad(-22.5)
	lunge_direction = (mouse_position - player.global_position).normalized()

	match index:
		0:
			#weaponSprite.flip_h = false
			weaponSprite.flip_v = false
			weaponSprite.play("swing")
			animatedSprite.frame = 0
			animatedSprite.play("action")
		1:
			#weaponSprite.play_backwards("swing")
			weaponSprite.play_backwards("swing")
			animatedSprite.frame = 0
			animatedSprite.play("action")
		2:
			#weaponSprite.flip_h = true
			weaponSprite.flip_v = true
			weaponSprite.play("swing")
			animatedSprite.frame = 0
			animatedSprite.play("action")
			#weaponSprite.play("lunge")

func _on_physics_process(delta: float) -> void:
	var move_input = GameInputEvents.movement_input()

	if attack_started:
		timer += delta
		attack_motion_time += delta

		# Eased lunge motion
		var t = clamp(attack_motion_time / attack_durations[current_attack], 0, 1)
		var eased_t = easing_curve.sample(t)

		# Directional tweaks per swing index
		var lunge_vec := Vector2.ZERO
		match current_attack:
			0:
				lunge_vec = lunge_direction * lunge_speed * eased_t  # Forward
			1:
				lunge_vec = -lunge_direction * lunge_speed * eased_t  # Backward
			2:
				lunge_vec = lunge_direction * (lunge_speed * 1.3) * eased_t  # Forward burst

		# Add player input (micro movement)
		if move_input != Vector2.ZERO:
			lunge_vec += move_input.normalized() * 50 * movement_influence

		player.velocity = lunge_vec
		player.move_and_slide()

		# End attack motion
		if timer >= attack_durations[current_attack]:
			if current_attack < 2:
				attack_started = false
				awaiting_input = true
				timer = 0.0
			else:
				transition.emit("ActionIdle")

	elif awaiting_input:
		timer += delta

		var move_vec = Vector2.ZERO
		if GameInputEvents.movement_input() != Vector2.ZERO:
			move_vec = GameInputEvents.movement_input().normalized() * 50 * movement_influence

		player.velocity = move_vec
		player.move_and_slide()

		if timer >= combo_input_window:
			transition.emit("ActionIdle")

	else:
		# Allow light movement even outside attack window
		var move_vec = GameInputEvents.movement_input().normalized() * player.speed * movement_influence
		player.velocity = move_vec
		player.move_and_slide()

func _on_next_transitions() -> void:
	if awaiting_input and GameInputEvents.melee_pressed():
		current_attack += 1
		start_attack(current_attack)
	elif !attack_started and !awaiting_input and GameInputEvents.is_momement_input():
		transition.emit("ActionMove")
