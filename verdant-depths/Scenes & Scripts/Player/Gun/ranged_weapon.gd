extends Node2D

@export var bullet_scene: PackedScene
@export var fire_rate: float = 5.0 # bullets per second
@export var shot_type: String = "single" # or "shotgun", "sniper", etc.

@export var crop_type: String = "carrot"

@export var clip_size: int = 5
@export var reload_time: float = 1.0
var _current_ammo: int
var _reloading := false
@onready var muzzle: Node2D = $Muzzle
var _can_fire := true
var _is_firing := false

var gun_ui

func _ready():
	gun_ui = get_tree().get_first_node_in_group("gun_ui")
	set_process(true)
	initialize()

func initialize():
	var gun_data = InventoryManager.get_current_gun()

	crop_type = gun_data.get("crop_type", "carrot")
	fire_rate = gun_data.get("fire_rate", 5.0)
	shot_type = gun_data.get("shot_type", "single")
	clip_size = gun_data.get("clip_size", 5)
	reload_time = gun_data.get("reload_time", 1.0)

	_current_ammo = gun_data.get("current_ammo", clip_size) # use saved value or start full
	_reloading = false
	_can_fire = true

func _process(_delta):
	look_at(get_global_mouse_position())

	_is_firing = GameInputEvents.is_fire_pressed()
	if _is_firing:
		_try_fire()

	if GameInputEvents.is_reload_pressed():
		_reload()
	
	if GameInputEvents.is_switch_gun_next_pressed():
		_switch_gun(1)

	if GameInputEvents.is_switch_gun_prev_pressed():
		_switch_gun(-1)



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
	if InventoryManager.get_crop_ammo(crop_type) <= 0:
		print("No", crop_type, "in reserve!")
		return

	_reloading = true
	print("Reloading", crop_type, "...")

	await get_tree().create_timer(reload_time).timeout

	var needed = clip_size - _current_ammo
	var available = InventoryManager.get_crop_ammo(crop_type)
	var to_reload = min(needed, available)

	if InventoryManager.use_crop_ammo(crop_type, to_reload):
		_current_ammo += to_reload
		
	gun_ui.update_clip_ammo(_current_ammo)

	_reloading = false
	print("Reloaded ", crop_type, "!")

func _switch_gun(offset: int):
	var old_index = InventoryManager.selected_gun_index
	InventoryManager.guns[old_index]["current_ammo"] = _current_ammo

	var new_index = (old_index + offset) % InventoryManager.guns.size()
	if new_index < 0:
		new_index = InventoryManager.guns.size() - 1

	InventoryManager.switch_gun(new_index)
	initialize()

	gun_ui.update_ui()
	gun_ui.update_clip_ammo(_current_ammo)


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
	gun_ui.update_clip_ammo(_current_ammo)

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
		gun_ui.update_clip_ammo(_current_ammo)

func _fire_sniper():
	# Could add charging, delay, etc.
	_fire_single()
	
