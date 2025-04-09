extends NodeState

@export var player: Player
@export var animatedSprite: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D
@export var attack_offset_node: Node2D

func _ready() -> void:
	hit_component_collision_shape.disabled = true
	#hit_component_collision_shape.position = Vector2(0,0)

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	if !animatedSprite.is_playing():
		transition.emit("Idle")

func _on_enter() -> void:
	hit_component_collision_shape.disabled = false
	
	if animatedSprite.flip_h:
		attack_offset_node.scale = Vector2(-1,1)
	else:
		attack_offset_node.scale = Vector2(1,1)
		
	#hit_component_collision_shape.position = Vector2(9,-5)
	animatedSprite.play("sword_side")

func _on_exit() -> void:
	hit_component_collision_shape.disabled = true
	animatedSprite.stop()
