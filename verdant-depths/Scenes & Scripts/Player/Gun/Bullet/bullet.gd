extends Area2D

@export var base_speed := 80.0
@export var max_speed := 300.0
var speed := 0.0
var direction := Vector2.ZERO
var charge_progress := 1.0  # 0.0 to 1.0
var start_position := Vector2.ZERO

func initialize():
	speed = lerp(base_speed, max_speed, charge_progress)

func _ready():
	start_position = global_position

func _process(delta):
	#print(speed)
	#print(charge_progress)
	global_position += direction.normalized() * speed * delta
	
func _on_area_entered(area: Area2D) -> void:
	print(area.name)
	var body = area.get_parent()
	if body.is_in_group("enemies"):  # Make sure enemies are in this group!
		var damage = 1
		body.take_damage(damage, self)
