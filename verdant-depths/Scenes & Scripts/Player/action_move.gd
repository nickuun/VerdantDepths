extends NodeState

@export var player: Player
@export var animatedSprite: AnimatedSprite2D
@export var hitComponentOffset: Node2D

@export var speed = 50

func _on_physics_process(_delta : float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()


	if direction != Vector2.ZERO:
		player.velocity = direction * speed
		player.move_and_slide()

		# Face mouse position
		var mouse_position = player.get_global_mouse_position()
		var to_mouse = (mouse_position - player.global_position).normalized()
		hitComponentOffset.look_at(mouse_position)
		hitComponentOffset.rotation += deg_to_rad(0)

		if abs(to_mouse.x) >= abs(to_mouse.y):
			if to_mouse.x < 0:
				animatedSprite.play("walk_right")
				animatedSprite.flip_h = true
			else:
				animatedSprite.play("walk_right")
				animatedSprite.flip_h = false
		else:
			if to_mouse.y < 0:
				animatedSprite.play("walk_up")
				animatedSprite.flip_h = false
			else:
				animatedSprite.play("walk_down")
				animatedSprite.flip_h = false
	else:
		player.velocity = Vector2.ZERO

func _on_next_transitions() -> void:
	if !GameInputEvents.is_momement_input():
		transition.emit("ActionIdle")
	elif GameInputEvents.dodge_pressed():
		transition.emit("DodgeRoll")
	elif GameInputEvents.melee_pressed():
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
