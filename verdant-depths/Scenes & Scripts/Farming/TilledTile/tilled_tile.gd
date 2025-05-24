extends Node2D

@onready var soil_sprite := $SoilSprite
@onready var plant_sprite := $PlantSprite

# Placeholder seed/plant sprites
@export var seed_sprite: Texture2D
@export var sprout_sprite: Texture2D
@export var plant_sprite_full: Texture2D

var has_seed := false
var growth_stage := 0  # 0 = none, 1 = seed, 2 = sprout, 3 = plant

func plant_seed():
	if has_seed:
		return
	has_seed = true
	growth_stage = 1
	plant_sprite.animation = "Carrot"
	plant_sprite.frame = 0


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
	plant_sprite.play("Empty")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if not has_seed:
		plant_seed()
	else:
		advance_growth()
