extends NodeState

@export var player: Player
@export var animatedSprite: AnimatedSprite2D
@export var hitComponentOffset: Node2D
@export var gun : Node2D


@export var speed = 50

func _on_physics_process(_delta : float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()
	var speed_multiplier = 1.0

	#if player.current_tool == DataTypes.Tools.Shoot and Input.is_action_pressed("click"): 
		#if not gun.is_charging:
			#gun.start_charging()
		#speed_multiplier = 0.4  # slower while charging
	#elif gun.is_charging:
		#gun.stop_charging_and_fire()

	if direction != Vector2.ZERO:
		player.velocity = direction * speed * speed_multiplier
		player.move_and_slide()

		# Face mouse position
		var mouse_position = player.get_global_mouse_position()
		var to_mouse = (mouse_position - player.global_position).normalized()
		hitComponentOffset.look_at(mouse_position)
		hitComponentOffset.rotation += deg_to_rad(0)

		if abs(to_mouse.x) >= abs(to_mouse.y):
			var facing_right = to_mouse.x >= 0
			var moving_right = direction.x > 0
			var moving_left = direction.x < 0

			# Always face mouse direction
			animatedSprite.flip_h = not facing_right

			# Decide animation direction
			if (facing_right and moving_left) or (not facing_right and moving_right):
				# Walking opposite to facing → play backwards
				animatedSprite.play_backwards("run_right")
			else:
				# Walking same direction as facing → play normally
				animatedSprite.play("run_right")
		else:
			if to_mouse.y < 0:
				animatedSprite.play("run_up")
				animatedSprite.flip_h = false
			else:
				animatedSprite.play("run_down")
				animatedSprite.flip_h = false
	else:
		player.velocity = Vector2.ZERO

func _on_next_transitions() -> void:
	if !GameInputEvents.is_momement_input():
		transition.emit("ActionIdle")
	elif GameInputEvents.dodge_pressed():
		transition.emit("DodgeRoll")
	elif GameInputEvents.melee_pressed() and not is_mouse_over_ui() and player.current_tool == DataTypes.Tools.Attack:
		if ComboManager.is_combo_available():
			transition.emit("MeleeAttack")
		else:
			print("combo not available, resetting from action_move")
			ComboManager.reset_combo()
			transition.emit("MeleeAttack")



func _on_enter() -> void:
	pass

func _on_exit() -> void:
	animatedSprite.stop()

func is_mouse_over_ui() -> bool:
	return get_viewport().gui_get_hovered_control() != null
