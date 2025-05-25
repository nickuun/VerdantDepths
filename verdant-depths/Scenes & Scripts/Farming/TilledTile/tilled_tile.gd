extends Node2D

@onready var soil_sprite := $SoilSprite
@onready var plant_sprite := $PlantSprite

# Placeholder seed/plant sprites
@export var seed_sprite: Texture2D
@export var sprout_sprite: Texture2D
@export var plant_sprite_full: Texture2D

@export var min_yield := 1
@export var max_yield := 3
@export var drop_scene: PackedScene 

var has_seed := false
var growth_stage := 0  # 0 = none, 1 = seed, 2 = sprout, 3 = plant

func _ready() -> void:
	print("TILE PLACED ")

func plant_seed():
	if has_seed:
		return
	has_seed = true
	growth_stage = 1
	plant_sprite.animation = "Carrot"
	plant_sprite.frame = 0

	# Randomize growth interval: base 10s ± 20%
	var base_duration = 10.0
	var randomized = base_duration * (1.0 + randf_range(-0.2, 0.2))
	var ms = int(randomized * 1000.0)

	PlantManager.register_plant(self, ms)

func advance_growth():
	if not has_seed:
		return
	match growth_stage:
		1:
			growth_stage = 2
			plant_sprite.frame = growth_stage -1
		2:
			growth_stage = 3
			plant_sprite.frame = growth_stage -1

		_:
			print("Plant is fully grown!")

func clear_tile():
	has_seed = false
	growth_stage = 0
	plant_sprite.animation = "Empty"
	
	#plant_sprite.frame = -1  # Hides it (or use a blank frame)


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("TIME FOR HARVEST? GROWTH STAGE ->", growth_stage)
	if growth_stage == 3:
		print("Harvesting plant!")
		call_deferred("harvest")


func harvest():
	# Reset tile
	clear_tile()

	# Random number of seed drops
	var drops = randi_range(min_yield, max_yield)

	for i in range(drops):
		spawn_drop()

		
func spawn_drop():
	if drop_scene:
		var drop = drop_scene.instantiate()
		get_tree().current_scene.add_child(drop)
		
		drop.global_position = global_position

		# Random launch direction
		var angle = randf_range(-PI / 4, PI / 4)
		var distance = randf_range(32, 64)
		var target = global_position + Vector2.RIGHT.rotated(angle) * distance

		drop.launch_to(target)
