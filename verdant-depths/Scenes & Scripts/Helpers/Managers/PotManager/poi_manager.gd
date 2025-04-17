# POIManager.gd
extends Node2D
class_name POIManager

func get_poi_names() -> Array:
	var names := []
	for child in get_children():
		if child is Node2D:
			names.append(child.name)
	return names

func get_poi_position(poi_name: String) -> Vector2:
	# has_node() will check for a direct child with that name
	if has_node(poi_name):
		var node := get_node(poi_name) as Node2D
		return node.global_position
	return Vector2.ZERO

func get_random_poi_name() -> String:
	var names := get_poi_names()
	if names.is_empty():
		return ""
	return names[randi() % names.size()]

func get_random_poi_position() -> Vector2:
	var name := get_random_poi_name()
	if name != "":
		return get_poi_position(name)
	return Vector2.ZERO
