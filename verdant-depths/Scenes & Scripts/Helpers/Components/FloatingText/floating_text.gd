extends Node2D

@onready var label := $Label

func setup(text: String, color := Color.WHITE, size := 16, duration := 2.0):
	label.text = text

	# Safe label settings assignment
	if label.label_settings == null:
		label.label_settings = LabelSettings.new()
	else:
		label.label_settings = label.label_settings.duplicate()

# Set the dynamic style
	label.label_settings.font_size = size
	label.label_settings.font_color = color
	label.label_settings.outline_size = 2  # 🟢 This is REQUIRED
	label.label_settings.outline_color = Color.BLACK  # Or whatever border you want

	# 🎯 Burst in any direction — strong pop, then ease out
	var angle = randf_range(0, TAU)  # Random direction (0 to 2π radians)
	var strength = randf_range(32.0, 64.0)  # Speed of the burst
	var offset = Vector2.RIGHT.rotated(angle) * strength

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "position", position + offset, duration)
	tween.parallel().tween_property(label, "modulate:a", 0.0, duration)
	tween.parallel().tween_property(self, "rotation", randf_range(-0.3, 0.3), duration)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, 0.2)
	tween.tween_callback(queue_free)
