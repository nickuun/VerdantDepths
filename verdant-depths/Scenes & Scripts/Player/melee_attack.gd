extends NodeState

@export var player: Player
@export var animatedSprite: AnimatedSprite2D
@export var hitComponentOffset: Node2D
@export var weaponSprite: AnimatedSprite2D

@export var move_distances := [10, 10, 25]  # Steps per hit
@export var attack_durations := [0.1, 0.15, 0.2]  # Duration per attack
@export var combo_input_window := 0.3
@export var combo_cooldown := 0.6  # Optional cooldown before new combo

var current_attack := 0
var timer := 0.0
var awaiting_input := false
var attack_started := false

func _on_enter() -> void:
	current_attack = 0
	start_attack(current_attack)

func _on_exit() -> void:
	weaponSprite.stop()
	attack_started = false
	awaiting_input = false
	CooldownTracker.start_cooldown(combo_cooldown)

func start_attack(index: int) -> void:
	attack_started = true
	timer = 0.0
	awaiting_input = false

	# Face the mouse
	var mouse_position = player.get_global_mouse_position()
	hitComponentOffset.look_at(mouse_position)
	hitComponentOffset.rotation += deg_to_rad(-22.5)

	# Move slightly in the attack direction (mouse-based)
	var direction = (mouse_position - player.global_position).normalized()
	player.global_position += direction * move_distances[index]

	match index:
		0:
			weaponSprite.play("swing")
		1:
			weaponSprite.play_backwards("swing")
		2:
			weaponSprite.play("lunge")

func _on_physics_process(delta: float) -> void:
	if attack_started:
		timer += delta

		if timer >= attack_durations[current_attack]:
			if current_attack < 2:
				# Enter combo window
				awaiting_input = true
				attack_started = false
				timer = 0.0
			else:
				# Final attack → return to idle
				transition.emit("ActionIdle")
	elif awaiting_input:
		timer += delta
		if timer >= combo_input_window:
			transition.emit("ActionIdle")

func _on_next_transitions() -> void:
	if awaiting_input and GameInputEvents.melee_pressed():
		current_attack += 1
		start_attack(current_attack)
	elif !attack_started and !awaiting_input:
		# Allow player to freely return to movement
		if GameInputEvents.is_momement_input():
			transition.emit("ActionMove")
