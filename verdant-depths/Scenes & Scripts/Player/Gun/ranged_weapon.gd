extends Node2D

@export var bullet_scene: PackedScene
@export var fire_rate: float = 5.0 # bullets per second
@export var shot_type: String = "single" # or "shotgun", "sniper", etc.

@export var clip_size: int = 5
@export var reload_time: float = 1.0
var _current_ammo: int
var _reloading := false


@onready var muzzle: Node2D = $Muzzle

var _can_fire := true
var _is_firing := false

func _ready():
	set_process(true)
	_current_ammo = clip_size

func _process(_delta):
	look_at(get_global_mouse_position())

	_is_firing = GameInputEvents.is_fire_pressed()
	if _is_firing:
		_try_fire()

	if GameInputEvents.is_reload_pressed():
		_reload()


func _try_fire():
	if not _can_fire or _reloading:
		return

	if _current_ammo <= 0:
		_reload()
		return

	_can_fire = false
	_current_ammo -= 1
	_fire()
	await get_tree().create_timer(1.0 / fire_rate).timeout
	_can_fire = true

func _reload():
	if _reloading:
		return
	_reloading = true
	print("Reloading...")
	await get_tree().create_timer(reload_time).timeout
	_current_ammo = clip_size
	_reloading = false
	print("Reloaded!")


func _fire():
	match shot_type:
		"single":
			_fire_single()
		"shotgun":
			_fire_shotgun()
		"sniper":
			_fire_sniper()
		_:
			_fire_single()

func _fire_single():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = muzzle.global_position
	bullet.rotation = muzzle.global_rotation
	var direction = Vector2.RIGHT.rotated(rotation)
	bullet.direction = direction
	bullet.initialize()
	get_tree().current_scene.add_child(bullet)

func _fire_shotgun():
	for i in range(5): # Example: 5 pellets
		var bullet = bullet_scene.instantiate()
		bullet.global_position = muzzle.global_position
		var spread = deg_to_rad(randf_range(-10, 10))
		bullet.rotation = muzzle.global_rotation + spread
		var direction = Vector2.RIGHT.rotated(rotation)
		bullet.direction = direction
		bullet.initialize()
		get_tree().current_scene.add_child(bullet)

func _fire_sniper():
	# Could add charging, delay, etc.
	_fire_single()
