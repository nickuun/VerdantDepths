
extends NodeState

@export var character: CharacterBody2D
@export var animated_sprite_2d: Node2D
@export var navigation_agent_2d: NavigationAgent2D
@export var min_speed: float = 60.0
@export var max_speed: float = 90.0

var poi_manager: POIManager
var poi_names: Array = []
var poi_index: int = 0
var speed: float

func _ready() -> void:
	navigation_agent_2d.velocity_computed.connect(on_safe_velocity_computed)
	call_deferred("_deferred_setup")

func _deferred_setup() -> void:
	poi_manager = get_tree().get_first_node_in_group("poi_manager")
	poi_names = poi_manager.get_poi_names()

func _on_enter() -> void:
	if poi_names.is_empty():
		transition.emit("Idle")
		return
	animated_sprite_2d._play_animation("walk")
	_move_to_next_poi()

func _move_to_next_poi() -> void:
	var target_name = poi_names[poi_index]
	var target_pos = poi_manager.get_poi_position(target_name)
	navigation_agent_2d.target_position = target_pos
	speed = randf_range(min_speed, max_speed)

func _on_physics_process(_delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		# advance to the next POI
		poi_index = (poi_index + 1) % poi_names.size()
		character.velocity = Vector2.ZERO
		transition.emit("Idle")
		return

	var next_pos = navigation_agent_2d.get_next_path_position()
	var dir = character.global_position.direction_to(next_pos)
	var vel = dir * speed

	# flip sprite on X
	animated_sprite_2d.flip_h = vel.x < 0

	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.velocity = vel
	else:
		character.velocity = vel
		character.move_and_slide()

func on_safe_velocity_computed(safe_velocity: Vector2) -> void:
	character.velocity = safe_velocity
	animated_sprite_2d.flip_h = safe_velocity.x < 0
	character.move_and_slide()

func _on_next_transitions() -> void:
	if not navigation_agent_2d.is_navigation_finished():
		return
	# after IdleState times out, this state will re‑enter and call _on_enter()
	# so nothing to do here unless you want a custom trigger
	pass

func _on_exit() -> void:
	animated_sprite_2d.stop()
