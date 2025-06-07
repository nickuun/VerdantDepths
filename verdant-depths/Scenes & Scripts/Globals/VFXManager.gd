extends Node

var HitFlashScene: PackedScene = preload("res://Scenes & Scripts/Helpers/Effects/HitFlash/hit_flash.tscn")
var DamageParticlesScene := preload("res://Scenes & Scripts/Particles/DamageParticleHit/damage_particles.tscn")

func spawn_hit_flash(target_node: Node2D, offset_range := 4.0):
	if not is_instance_valid(target_node):
		return

	var flash = HitFlashScene.instantiate()
	
	# Random small offset
	var offset = Vector2(
		randf_range(-offset_range, offset_range),
		randf_range(-offset_range, offset_range)
	)
	
	flash.position = offset

	# Add to target (optional: use target.get_parent() if you want it outside the target)
	target_node.add_child(flash)

func spawn_damage_particles(target: Node2D, direction: Vector2, color: Color = Color.WHITE):
	if not is_instance_valid(target):
		return

	var burst := DamageParticlesScene.instantiate()
	burst.position = Vector2.ZERO
	burst.rotation = direction.angle()

	# Set color if the scene supports it
	if burst.has_method("set_color"):
		burst.set_color(color)

	target.add_child(burst)
