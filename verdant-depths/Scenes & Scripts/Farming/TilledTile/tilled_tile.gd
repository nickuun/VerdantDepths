extends Node2D

@onready var soil_sprite := $SoilSprite
@onready var plant_sprite := $PlantSprite

@export var min_yield := 1
@export var max_yield := 3
@export var shared_drop_scene: PackedScene 
var plant_data: PlantData = null
@export var default_plant: PlantData = preload("res://Scenes & Scripts/Globals/PlantData/Carrot.tres")

var has_seed := false
var growth_stage := 0  # 0 = none, 1 = seed, 2 = sprout, 3 = plant

func _ready() -> void:
	print("TILE PLACED ")

func plant_seed():
	if has_seed:
		return

	var data = GameState.get_current_plant_data()
	if data == null:
		print("No valid plant data for:", GameState.current_plant_name)
		return

	has_seed = true
	growth_stage = 1
	plant_data = data

	plant_sprite.animation = plant_data.animation_name
	plant_sprite.frame = 0

	var randomized = plant_data.growth_time * (1.0 + randf_range(-0.2, 0.2))
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
	clear_tile()

	var drops = randi_range(plant_data.min_yield, plant_data.max_yield)

	for i in range(drops):
		spawn_drop()

func spawn_drop():
	if shared_drop_scene:
		var drop = shared_drop_scene.instantiate()
		get_tree().current_scene.add_child(drop)

		drop.global_position = global_position

		var angle = randf_range(-PI / 4, PI / 4)
		var distance = randf_range(32, 64)
		var target = global_position + Vector2.RIGHT.rotated(angle) * distance

		#drop.plant_data = plant_data  # ← this tells the drop what plant it is
		drop.launch_to(target)
