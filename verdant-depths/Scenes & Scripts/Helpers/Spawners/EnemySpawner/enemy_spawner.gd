extends Node2D

@export var melee_enemy_scene: PackedScene

func _process(_delta):
	if Input.is_action_just_pressed("hotkey-1"):  # REFACTOR
		spawn_enemy_at_mouse()

func spawn_enemy_at_mouse():
	if not melee_enemy_scene:
		print("No melee enemy scene assigned!")
		return

	var enemy = melee_enemy_scene.instantiate()
	enemy.global_position = get_global_mouse_position()
	get_tree().current_scene.add_child(enemy)
