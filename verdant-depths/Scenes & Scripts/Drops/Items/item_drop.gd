extends Area2D

@export var drop_type = "carrot"

@export var arc_height := randf_range(24, 48)
@export var lifetime := 8.0
@export var time_to_land := 0.4 + randf_range(-0.05, 0.05)

var start_position := Vector2.ZERO
var target_position := Vector2.ZERO
var elapsed := 0.0
var landed := false

func launch_to(target: Vector2):
	start_position = global_position
	target_position = target
	elapsed = 0.0
	landed = false
	$CollisionShape2D.set_deferred("disabled", true)

func _process(delta):
	if not landed:
		elapsed += delta
		var t = clamp(elapsed / time_to_land, 0.0, 1.0)
		var height = -4 * arc_height * t * (t - 1.0)  # Simple parabola
		global_position = start_position.lerp(target_position, t) + Vector2(0, -height)

		if t >= 1.0:
			landed = true
			_on_landed()
	else:
		lifetime -= delta
		if lifetime <= 0.0:
			queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("player picked up: ", drop_type)

		if drop_type == "coin":
			InventoryManager.add_coins(1)
		else:
			InventoryManager.add_crop(drop_type, 1)

		self.queue_free()

func _on_landed():
	$CollisionShape2D.set_deferred("disabled", false)
	#if has_node("AnimatedSprite2D"):
		#$AnimatedSprite2D.play(drop_animation)
	print("Drop landed:", drop_type)
