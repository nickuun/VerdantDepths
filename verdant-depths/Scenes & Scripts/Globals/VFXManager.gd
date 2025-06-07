extends Node

var HitFlashScene: PackedScene = preload("res://Scenes & Scripts/Helpers/Effects/HitFlash/hit_flash.tscn")

func spawn_hit_flash(target_node: Node2D, offset_range := 4.0):
	if not is_instance_valid(target_node):
		return

	var flash = HitFlashScene.instantiate()
	
	# Random small offset
	var offset = Vector2(
		randf_range(-offset_range, offset_range),
		randf_range(-offset_range, offset_range)
	)
	
	flash.position = offset

	# Add to target (optional: use target.get_parent() if you want it outside the target)
	target_node.add_child(flash)
