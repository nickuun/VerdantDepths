extends Node

var tracked_plants: Array = []

func register_plant(tile: Node2D, growth_duration: int) -> void:
	print("REGISTERING NEW PLANT")
	tracked_plants.append({
		"tile": tile,
		"start_time": Time.get_ticks_msec(),
		"growth_duration": growth_duration,
		"stage": tile.growth_stage
	})

func _process(_delta: float) -> void:
	var now := Time.get_ticks_msec()

	var i := tracked_plants.size() - 1
	while i >= 0:
		var plant_data = tracked_plants[i]
		var tile = plant_data["tile"]
		var growth_duration = plant_data["growth_duration"]
		var time_since_start = now - plant_data["start_time"]

		var stages_to_advance = int(time_since_start / growth_duration)

		if stages_to_advance > 0 and tile.growth_stage < 3:
			tile.advance_growth()
			plant_data["start_time"] = now
			plant_data["stage"] = tile.growth_stage

		if tile.growth_stage >= 3:
			tracked_plants.remove_at(i)

		i -= 1
