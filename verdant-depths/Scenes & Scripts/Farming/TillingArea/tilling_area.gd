extends Node2D

@export var grid_size := 16
@export var max_till_distance := 30.0
@export var tile_scene: PackedScene
@export var action_preview: NodePath
@export var offset := Vector2(0, -8)

@onready var preview := get_node(action_preview)
@onready var player := get_tree().get_first_node_in_group("player")

var tilled_positions := {}

func _process(_delta):
	if !is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
		if player == null:
			return  # Still no player

	var current_tool = player.current_tool
	
	var mouse_pos = get_global_mouse_position()
	var snapped_pos = mouse_pos.snapped(Vector2(grid_size, grid_size))
	var in_range = player.global_position.distance_to(snapped_pos) <= max_till_distance

	match current_tool:
		DataTypes.Tools.Dig, DataTypes.Tools.Plant, DataTypes.Tools.Water:
			self.show()
			preview.show_preview_at(snapped_pos)

			var already_tilled = tilled_positions.has(snapped_pos)
			
			# For Dig: only allow tilling empty and in-range
			if current_tool == DataTypes.Tools.Dig:
				preview.set_preview_mode(!in_range or already_tilled)
				if Input.is_action_just_pressed("click") and in_range and not already_tilled:
					place_tile(snapped_pos)

			# For Plant: only allow planting on existing tilled tile
			elif current_tool == DataTypes.Tools.Plant:
				preview.set_preview_mode(!in_range or not already_tilled)
				if Input.is_action_just_pressed("click") and in_range and already_tilled:
					var tile = tilled_positions[snapped_pos]
					if tile.has_method("plant_seed"):
						tile.plant_seed()
			
			elif current_tool == DataTypes.Tools.Water:
				preview.set_preview_mode(!in_range or not already_tilled)
				if Input.is_action_just_pressed("click") and in_range and already_tilled:
					var tile = tilled_positions[snapped_pos]
					if tile.has_method("advance_growth"):
						tile.advance_growth()

		_:
			self.hide()
			preview.hide()

func place_tile(pos: Vector2):
	print("Placing tile")
	var tile = tile_scene.instantiate()
	tile.position = pos
	tile.position += offset
	#self.get_tree().root.add_child(tile)
	self.get_parent().add_child(tile)
	tilled_positions[pos] = tile
