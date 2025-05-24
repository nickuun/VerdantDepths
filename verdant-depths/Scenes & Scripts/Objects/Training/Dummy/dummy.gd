extends Node2D

@onready var sprite := $AnimatedSprite2D

var hit_animations := ["Hit1", "Hit2", "Hit3"]
var idle_animations := ["Idle1", "Idle2"]
var is_hit := false

func _ready():
	randomize()
	sprite.play(idle_animations.pick_random())

func _on_DummyArea_area_entered(area: Area2D) -> void:
	if is_hit:
		return
	print("Ouch! 😵 Got hit by:", area.name)
	react_to_hit(area)

func react_to_hit(area: Area2D):
	
	FloatingTextManager.show(
	str(randi_range(10, 30)),                # Text (e.g. damage number)
	global_position + Vector2(0, -20),       # Appears just above dummy                                # Optional: duration
)
	ScreenShakeManager.shake(0.8, 0.2)
	is_hit = true
	
	# Flip direction based on hit origin
	var hit_direction = (sprite.global_position - area.global_position).normalized()
	sprite.flip_h = hit_direction.x < 0

	# Randomize animation speed
	sprite.speed_scale = randf_range(0.8, 1.2)

	# Play random hit animation
	var chosen_hit = hit_animations.pick_random()
	sprite.play(chosen_hit)

	# Wait until it finishes
	await sprite.animation_finished

	# Reset speed and return to idle
	sprite.speed_scale = 1.0
	sprite.play(idle_animations.pick_random())
	is_hit = false
