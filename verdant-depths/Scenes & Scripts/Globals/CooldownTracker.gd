extends Node2D

var cooldown_time := 0.0

func is_ready() -> bool:
	return cooldown_time <= 0

func start_cooldown(duration: float):
	cooldown_time = duration

func _process(delta: float) -> void:
	if cooldown_time > 0:
		cooldown_time -= delta
