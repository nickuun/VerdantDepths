class_name Player
extends CharacterBody2D

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
@export var max_health: int = 6
var current_health: int
@export var health_ui: PlayerHealthUI

var last_direction: Vector2  # Track last direction for idle animation
var is_hurt: bool = false

func _ready() -> void:
	current_health = max_health
	randomize()
	
func _physics_process(delta: float) -> void:	
	ComboManager.update(delta)

func _on_hit_component_area_entered(area: Area2D) -> void:
	print(area.name)
	var body = area.get_parent()
	if body.is_in_group("enemies"):  # Make sure enemies are in this group!
		var damage = GameState.get_current_plant_data().damage
		body.take_damage(damage, self)

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("PLAYER TAKE DAMAGE")
	if area.get_parent().is_in_group("enemies"):
		var source_pos = area.global_position
		take_damage(1, source_pos)

func take_damage(amount: int, source_position: Vector2) -> void:
	if is_in_hurt_state():
		return

	current_health -= amount
	print("Player took damage. Health:", current_health)

	if current_health <= 0:
		die()
	enter_hurt_state(source_position)
	health_ui.set_current_health(current_health)

func is_in_hurt_state() -> bool:
	return is_hurt

func enter_hurt_state(source_position: Vector2) -> void:
	is_hurt = true
	$StateMachine/HurtState.set_source_position(source_position)
	$StateMachine.transition_to("HurtState")
	$StateMachine/HurtState.set_source_position(source_position)

func die():
	print("Player died.")
	#queue_free()  # Or trigger a death animation, respawn, etc.
