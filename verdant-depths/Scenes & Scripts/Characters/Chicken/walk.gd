extends NodeState

@export var character: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var navigation_agent_2d: NavigationAgent2D
@export var min_speed: float = 5.0
@export var max_speed: float = 10.0

var walks_remaining: int = 0


var speed : float

func _ready() -> void:
	navigation_agent_2d.velocity_computed.connect(on_safe_velocity_computed)
	call_deferred("character_setup")
	
func character_setup()-> void:
	await get_tree().physics_frame

func set_movement_target()-> void:
	var target_position: Vector2 = NavigationServer2D.map_get_random_point(navigation_agent_2d.get_navigation_map(),navigation_agent_2d.navigation_layers,false)
	navigation_agent_2d.target_position = target_position
	speed = randf_range(min_speed, max_speed)

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		walks_remaining -= 1
		if walks_remaining <= 0:
			character.velocity = Vector2.ZERO
			transition.emit("Idle")
		else:
			set_movement_target()
		return
	
	var target_position = navigation_agent_2d.get_next_path_position()
	var target_direction: Vector2 = character.global_position.direction_to(target_position)

	var velocity: Vector2 = target_direction * speed
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.velocity = velocity
	else:
		animated_sprite_2d.flip_h = !(velocity.x < 0)
		character.velocity = velocity
		character.move_and_slide()

func _on_next_transitions() -> void:
	if navigation_agent_2d.is_navigation_finished():
		character.velocity = Vector2.ZERO
		transition.emit("Idle")

func _on_enter() -> void:
	walks_remaining = randi_range(1, 5)
	if randf() < 0.5:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("walk_alternative")
	set_movement_target()

func _on_exit() -> void:
	animated_sprite_2d.stop()
	
func on_safe_velocity_computed(safe_velocity:Vector2) -> void:
	character.velocity = safe_velocity
	animated_sprite_2d.flip_h = !(safe_velocity.x < 0)
	character.move_and_slide()
