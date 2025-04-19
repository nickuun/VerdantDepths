#@tool
extends Node2D

@export var animation_name: String = "walk"
@export var play_preview := true

@onready var body_sprite: AnimatedSprite2D = $Body
@onready var hair_sprite: AnimatedSprite2D = $Hair
@onready var tool_sprite: AnimatedSprite2D = $Tool

var _last_animation := ""
var _was_playing := false

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return
	
	if play_preview:
		if animation_name != _last_animation or !_was_playing:
			_play_animation(animation_name)
	else:
		body_sprite.stop()
		tool_sprite.stop()
		hair_sprite.stop()

	_last_animation = animation_name
	_was_playing = play_preview


func _play_animation(anim: String) -> void:
	
	#if not Engine.is_editor_hint():
		#return
	if body_sprite.sprite_frames.has_animation(anim):
		body_sprite.play(anim)
	if hair_sprite.sprite_frames.has_animation("style1_" + anim):
		hair_sprite.play("style1_" + anim)
	if tool_sprite.sprite_frames.has_animation(anim):
		tool_sprite.play(anim)
	
func stop():
	body_sprite.stop()
	hair_sprite.stop()
	tool_sprite.stop()

func set_flip_h(enabled: bool) -> void:
	body_sprite.flip_h = enabled
	hair_sprite.flip_h = enabled
	tool_sprite.flip_h = enabled
