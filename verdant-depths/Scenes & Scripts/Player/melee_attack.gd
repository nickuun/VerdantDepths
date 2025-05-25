extends NodeState

@export var player: Player
@export var animatedSprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer

@export var hitComponentOffset: Node2D
@export var hit_component_colliasion_shape: Node2D

@export var weaponSprite: AnimatedSprite2D

@export var attack_durations := [0.35, 0.15, 0.2]
@export var combo_input_window := 1.3
@export var combo_cooldown := 0.6
@export var movement_influence := 0.1
@export var lunge_distance := 30.0
@export var lunge_speed := 120.0

var current_attack := 0  # Only for local ease, but sourced from ComboManager

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
	#hit_component_collision_shape.disablead = false

	if ComboManager.is_combo_available():
		start_attack(false)
	else:
		start_attack(true)



func _on_exit() -> void:
	weaponSprite.play("empty")
	player.velocity = Vector2.ZERO
	attack_started = false
	awaiting_input = false
	CooldownTracker.start_cooldown(combo_cooldown)


func start_attack(force_fresh := false):
	if force_fresh:
		ComboManager.register_attack(true)
	else:
		ComboManager.register_attack()

	current_attack = ComboManager.get_current_attack()


	#print("⚔️ Start Attack | Current Index:", current_attack)

	timer = 0.0
	attack_motion_time = 0.0
	awaiting_input = false
	attack_started = true

	var mouse_position = player.get_global_mouse_position()
	hitComponentOffset.look_at(mouse_position)
	hitComponentOffset.rotation += deg_to_rad(-22.5)
	lunge_direction = (mouse_position - player.global_position).normalized()

	match current_attack:
		0:
			#print("➡️ Playing attack 0")
			animatedSprite.play("action")
			animatedSprite.frame = 0
			animation_player.play("Slash")

		1:
			#print("➡️ Playing attack 1")
			animation_player.play("Backslash")
			animatedSprite.frame = 0
			animatedSprite.play("action")
		2:
			#print("➡️ Playing attack 2")
			animation_player.play("Slash")
			animatedSprite.frame = 0
			animatedSprite.play("action")

func _on_physics_process(delta: float) -> void:
	#ComboManager.update(delta)
	
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
				lunge_vec = lunge_direction *  (lunge_speed * 0.5)  * eased_t  # Backward
			2:
				lunge_vec = lunge_direction * (lunge_speed * 1.5) * eased_t  # Forward burst
	
		# Add player input (micro movement)
		if move_input != Vector2.ZERO:
			lunge_vec += move_input.normalized() * 50 * movement_influence

		player.velocity = lunge_vec
		player.move_and_slide()

		# End attack motion
		if timer >= attack_durations[current_attack]:
			if ComboManager.is_combo_complete():
				ComboManager.reset_combo()
				transition.emit("ActionIdle")
			else:
				attack_started = false
				awaiting_input = true
				timer = 0.0


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
	if !attack_started and !awaiting_input and GameInputEvents.is_momement_input():
		transition.emit("ActionMove")

func end_attack_animation():
	print("called")
	transition.emit("ActionIdle")
