extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	sprite.play()
	sprite.animation_finished.connect(_on_animation_finished)
	sprite.speed_scale = randf_range(0.8, 1.2)

func _on_animation_finished():
	print("destroy hitflash sprite")
	queue_free()
