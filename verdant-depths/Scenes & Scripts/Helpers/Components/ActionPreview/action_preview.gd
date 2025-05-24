extends Node2D

@export var tile_size := Vector2(16, 16)
@export var pulse_speed := 2.0       # Breath cycles per second
@export var pulse_strength := 0.2    # How much it grows/shrinks (0.0–1.0)

@onready var corners := {
	"tl": $CornerTopLeft,
	"tr": $CornerTopRight,
	"bl": $CornerBottomLeft,
	"br": $CornerBottomRight
}

var time := 0.0

func _ready():
	update_corners()

func _process(delta):
	time += delta
	var scale_factor = 1.0 + sin(time * TAU * pulse_speed) * pulse_strength

	for corner in corners.values():
		corner.scale = Vector2.ONE * scale_factor

func set_size(new_size: Vector2):
	tile_size = new_size
	update_corners()

func update_corners():
	var half_size = tile_size / 2

	corners.tl.position = Vector2(-half_size.x, -half_size.y)
	corners.tr.position = Vector2(half_size.x, -half_size.y)
	corners.bl.position = Vector2(-half_size.x, half_size.y)
	corners.br.position = Vector2(half_size.x, half_size.y)

func show_preview_at(position: Vector2):
	global_position = position
	visible = true

func hide_preview():
	visible = false

func set_preview_mode(enabled: bool):
	
	var target_modulate
	if enabled:
		target_modulate = Color(1, 1, 1, 0.35)
	else:
		target_modulate = Color(1, 1, 1, 1)
		
	for corner in corners.values():
		corner.modulate = target_modulate
