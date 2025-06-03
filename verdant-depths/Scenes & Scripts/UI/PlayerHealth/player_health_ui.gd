class_name PlayerHealthUI
extends Control

@export var full_heart_texture: Sprite2D
@export var half_heart_texture: Sprite2D
@export var empty_heart_texture: Sprite2D

var max_health: int = 6  # Example: 3 hearts
var current_health: int = 6

func _ready() -> void:
	update_hearts()

func set_max_health(value: int) -> void:
	max_health = value
	update_hearts()

func set_current_health(value: int) -> void:
	current_health = clamp(value, 0, max_health)
	update_hearts()

func update_hearts() -> void:
	var heart_width = 19
	var heart_height = 15

	# Number of hearts to display
	var total_hearts = int(ceil(max_health / 2.0))

	# Full hearts: every 2 health points
	var full_hearts = int(current_health / 2)

	# Half heart if there's an odd health point
	print("current health:")
	print(current_health)
	var has_half_heart = current_health % 2 == 1
	print("has_half_heart", has_half_heart)

	# Calculate pixel widths for each layer
	var full_width = full_hearts * heart_width
	var half_width = ((heart_width * full_hearts) + 19) if has_half_heart else 0
	var empty_width = total_hearts * heart_width

	# Update regions for each sprite layer
	full_heart_texture.region_rect = Rect2(Vector2.ZERO, Vector2(full_width, heart_height))
	half_heart_texture.region_rect = Rect2(Vector2.ZERO, Vector2(half_width, heart_height))
	empty_heart_texture.region_rect = Rect2(Vector2.ZERO, Vector2(empty_width, heart_height))
