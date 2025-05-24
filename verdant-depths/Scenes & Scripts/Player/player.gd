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

func _ready() -> void:
	randomize()
	
func _physics_process(delta: float) -> void:	
	ComboManager.update(delta)
	#$ActionPreview.show_preview_at(self.position)
	#$ActionPreview.set_preview_mode(false)

func _on_hit_component_area_entered(area: Area2D) -> void:
	print(area.name)
