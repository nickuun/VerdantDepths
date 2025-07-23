extends Control
class_name CustomMouse

@onready var cursor_sprite: AnimatedSprite2D = $CharacterBody2D/CursorSprite
@export var JointB :  Node2D

func _ready() -> void:
	if JointB:
		$PinJoint2D.node_b = JointB.get_path()
		JointB.global_position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()
	$PinJoint2D.global_position = get_global_mouse_position()

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
