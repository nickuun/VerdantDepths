class_name Player
extends CharacterBody2D

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
#var speed = 75  # Normal speed
#var dash_multiplier = 2.0  # Dash speed multiplier
var last_direction: Vector2  # Track last direction for idle animation
#
#@onready var animated_sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D
#
#func _physics_process(delta):
	#var direction = Input.get_vector("left", "right", "up", "down")
	#last_direction = direction
