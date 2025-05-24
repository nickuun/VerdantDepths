extends Node

@export var floating_text_scene: PackedScene = preload("res://Scenes & Scripts/Helpers/Components/FloatingText/floating_text.tscn")

func show(text: String, position: Vector2, color := Color.WHITE, size := 16, duration := 1.0):
	var instance = floating_text_scene.instantiate()
	instance.global_position = position
	get_tree().current_scene.add_child(instance)
	instance.setup(text, color, size, duration)
