extends NodeState

@export var player: Player
@export var animatedSprite: AnimatedSprite2D

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	if !animatedSprite.is_playing():
		transition.emit("Idle")

func _on_enter() -> void:
	animatedSprite.play("chop_side")

func _on_exit() -> void:
	animatedSprite.stop()
