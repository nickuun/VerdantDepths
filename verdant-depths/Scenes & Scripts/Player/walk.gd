extends NodeState

@export var player: Player
@export var animatedSprite: AnimatedSprite2D
@export var speed = 50 

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()
	
	if direction != Vector2.ZERO:
		var rounded_dir = get_cardinal_direction(direction)

		if rounded_dir == Vector2.UP:
			animatedSprite.play("walk_up")
			animatedSprite.flip_h = false
		elif rounded_dir == Vector2.DOWN:
			animatedSprite.play("walk_down")
			animatedSprite.flip_h = false
		elif rounded_dir == Vector2.LEFT:
			animatedSprite.play("walk_right")
			animatedSprite.flip_h = true
		elif rounded_dir == Vector2.RIGHT:
			animatedSprite.play("walk_right")
			animatedSprite.flip_h = false

		player.last_direction = rounded_dir
	
		player.velocity = direction * speed
		player.move_and_slide()
	
func _on_next_transitions() -> void:
	if !GameInputEvents.is_momement_input():
		transition.emit("Idle")

func _on_enter() -> void:
	pass

func _on_exit() -> void:
	animatedSprite.stop()

func get_cardinal_direction(dir: Vector2) -> Vector2:
	if dir == Vector2.ZERO:
		return Vector2.DOWN  # Default facing
	if abs(dir.x) >= abs(dir.y):
		return Vector2.LEFT if dir.x < 0 else Vector2.RIGHT
	else:
		return Vector2.UP if dir.y < 0 else Vector2.DOWN
