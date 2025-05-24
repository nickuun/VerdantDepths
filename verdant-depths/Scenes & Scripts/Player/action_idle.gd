extends NodeState

@export var player: Player
@export var aniSprite: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D
@export var hitComponentOffset: Node2D


func _on_process(_delta : float) -> void:
	# Face the mouse even while idling
	var mouse_position = player.get_global_mouse_position()
	var to_mouse = (mouse_position - player.global_position).normalized()
	hitComponentOffset.look_at(mouse_position)
	hitComponentOffset.rotation += deg_to_rad(0)
	var rounded_dir = get_cardinal_direction(to_mouse)

	if rounded_dir == Vector2.UP:
		aniSprite.play("idle_up")
		aniSprite.flip_h = false
	elif rounded_dir == Vector2.DOWN:
		aniSprite.play("idle_down")
		aniSprite.flip_h = false
	elif rounded_dir == Vector2.LEFT:
		aniSprite.play("idle_right")
		aniSprite.flip_h = true
	elif rounded_dir == Vector2.RIGHT:
		aniSprite.play("idle_right")
		aniSprite.flip_h = false

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	GameInputEvents.movement_input()
	
	if GameInputEvents.is_momement_input():
		#transition.emit("Walk")d
		transition.emit("ActionMove")
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
	aniSprite.stop()

## -------- HELPER FUNCTIONS BELOW --------
func get_cardinal_direction(dir: Vector2) -> Vector2:
	if dir == Vector2.ZERO:
		return Vector2.DOWN

	if abs(dir.x) >= abs(dir.y):
		return Vector2.LEFT if dir.x < 0 else Vector2.RIGHT
	else:
		return Vector2.UP if dir.y < 0 else Vector2.DOWN
