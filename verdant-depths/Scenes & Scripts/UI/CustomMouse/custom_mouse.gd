extends Control
class_name CustomMouse

@onready var cursor_sprite: AnimatedSprite2D = $CursorSprite

func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()

	# React to input
	if GameInputEvents.use_tool():
		play_click_animation()
	else:
		play_idle_animation()

func play_click_animation():
	if cursor_sprite.animation != "click":
		cursor_sprite.play("click")

func play_idle_animation():
	if cursor_sprite.animation != "idle":
		cursor_sprite.play("idle")
