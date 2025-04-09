extends NodeState 

@export var player: Player
@export var aniSprite: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D

var direction: Vector2

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	#print(player.last_direction)
	var rounded_dir = get_cardinal_direction(player.last_direction)
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
	
func _on_next_transitions() -> void:
	GameInputEvents.movement_input()
	if GameInputEvents.is_momement_input():
		transition.emit("Walk")
	
	if player.current_tool == DataTypes.Tools.AxeWood and GameInputEvents.use_tool():
		transition.emit("Chopping")
		
	if player.current_tool == DataTypes.Tools.TillGround and GameInputEvents.use_tool():
		transition.emit("Tilling")
	
	if player.current_tool == DataTypes.Tools.WaterCrops and GameInputEvents.use_tool():
		transition.emit("Watering")

func _on_enter() -> void:
	pass

func _on_exit() -> void:
	aniSprite.stop()


## -------- HELPER FUNCTIONS BELOW --------
func get_cardinal_direction(dir: Vector2) -> Vector2:
	# If there's no movement, return down by default (or whatever you prefer)
	if dir == Vector2.ZERO:
		return Vector2.DOWN

	# Always prioritize left/right if there's meaningful x movement
	if abs(dir.x) >= abs(dir.y):
		return Vector2.LEFT if dir.x < 0 else Vector2.RIGHT
	else:
		return Vector2.UP if dir.y < 0 else Vector2.DOWN
