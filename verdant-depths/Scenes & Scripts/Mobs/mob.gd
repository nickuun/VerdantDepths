extends CharacterBody2D

var speed = 50  # Movement speed
var change_direction_time = 0.5  # How often the enemy changes direction
#todo - random change time

var direction = Vector2.ZERO  # Current movement direction

func _ready():
	# Call change_direction every `change_direction_time` seconds
	change_direction()
	$Timer.wait_time = change_direction_time
	$Timer.start()

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()

# Function to pick a new random direction
func change_direction():
	var angle = randf() * TAU  # Random angle in radians (TAU = 2 * PI)
	direction = Vector2(cos(angle), sin(angle))  # Convert angle to direction

# Connected to the Timer's timeout signal in the editor
func _on_Timer_timeout():
	change_direction()
