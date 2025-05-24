extends Node

var current_attack := 0
var combo_timer := 0.0
var combo_input_window := 1.3 
var combo_active := false
var max_combo_index := 2

func register_attack(force_fresh := false):
	if force_fresh:
		current_attack = 0
	else:
		if current_attack != 2:
			current_attack = min(current_attack + 1, max_combo_index)
		else: 
			current_attack = 0
		print("Clamping to max combo", current_attack)

	combo_timer = combo_input_window
	combo_active = true
	print("🌀 Combo Registered | Attack:", current_attack, "| Timer:", combo_timer)

func update(delta: float):
	#print("update caled")
	if combo_active:
		combo_timer -= delta
		#print("⏳ Combo Timer:", combo_timer)
		if combo_timer <= 0:
			reset_combo()

func reset_combo():
	print("❌ Combo Reset")
	current_attack = 0
	combo_active = false

func is_combo_available() -> bool:
	return combo_active and combo_timer > 0

func is_combo_complete() -> bool:
	return current_attack >= max_combo_index

func get_current_attack() -> int:
	return current_attack
