extends Node2D

@export var grid_size := 16
@export var max_till_distance := 30.0
@export var tile_scene: PackedScene
@export var action_preview: NodePath  # Drag your ActionPreview instance
@export var offset := Vector2(0,-8)

@onready var preview := get_node(action_preview)
@onready var player := get_tree().get_first_node_in_group("player")  # or use export var

var tilled_positions := {}

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	var snapped_pos = mouse_pos.snapped(Vector2(grid_size, grid_size))
	
	# Optional: clamp to region bounds
	# snapped_pos = clamp_to_bounds(snapped_pos)

	# Distance check
	var is_in_range = player.global_position.distance_to(snapped_pos) <= max_till_distance
	
	# Tilled already?
	var already_tilled = tilled_positions.has(snapped_pos)

	# Update preview
	preview.show_preview_at(snapped_pos)
	preview.set_preview_mode(!is_in_range)

	# Plant on action press
	if Input.is_action_just_pressed("plant_tile") and is_in_range and not already_tilled:
		place_tile(snapped_pos)

func place_tile(pos: Vector2):
	print("Placing tile")
	var tile = tile_scene.instantiate()
	tile.position = pos
	tile.position += offset
	self.get_tree().root.add_child(tile)
	tilled_positions[pos] = tile
