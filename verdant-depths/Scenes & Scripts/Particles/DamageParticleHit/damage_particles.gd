extends Node2D

@onready var particles := $CPUParticles2D

func _ready():
	particles.emitting = true
	# Wait for the particles to finish before freeing
	await get_tree().create_timer(particles.lifetime).timeout
	queue_free()

func set_color(color: Color) -> void:
	$CPUParticles2D.color = color
	
