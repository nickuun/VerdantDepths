extends Node

var crop_ammo: Dictionary = {
	"carrot": 0,
	"corn": 0,
	"potato": 0,
	"pumpkin": 0,
	"wheat": 0
}
var coins = 0
var seen_crops: Dictionary = {} # New: track whether we've seen a crop at all
var guns: Array = []
var selected_gun_index: int = 0

func _ready():
	add_crop("carrot", 50)
	add_crop("corn", 0)
	add_crop("potato", 10)
	add_crop("pumpkin", 3)
	add_crop("wheat", 3)
	
		# Add example guns
	add_gun({
		"name": "Carrot Blaster",
		"crop_type": "carrot",
		"fire_rate": 5.0,
		"shot_type": "single",
		"clip_size": 6,
		"reload_time": 1.0,
		"damage": 3
	})

	#add_gun({
		#"name": "Corn Shotgun",
		#"crop_type": "corn",
		#"fire_rate": 2.0,
		#"shot_type": "shotgun",
		#"clip_size": 2,
		#"reload_time": 1.5
	#})
	
	add_gun({
	"name": "Pumpkin Cannon",
	"crop_type": "pumpkin",
	"fire_rate": 1.0,
	"shot_type": "charged",
	"clip_size": 1,
	"reload_time": 2.0,
	"damage": 12
	})


	add_gun({
		"name": "Sniper Tuber",
		"crop_type": "potato",
		"fire_rate": 1.0,
		"shot_type": "sniper",
		"clip_size": 1,
		"reload_time": 2.0,
		"damage": 20
	})

func add_crop(crop_name: String, amount: int):
	print("adding crop: ", crop_name, " x ", amount)
	crop_ammo[crop_name] = crop_ammo.get(crop_name, 0) + amount
	seen_crops[crop_name] = true
	
func get_crop_ammo(crop_name: String) -> int:
	return crop_ammo.get(crop_name, 0)

func has_seen_crop(crop_name: String) -> bool:
	return seen_crops.has(crop_name) and seen_crops[crop_name]

func use_crop_ammo(crop_name: String, amount: int) -> bool:
	var current = get_crop_ammo(crop_name)
	if current < amount:
		return false
	crop_ammo[crop_name] = max(current - amount, 0)
	return true

func add_gun(gun_data: Dictionary):
	gun_data["current_ammo"] = gun_data.get("clip_size", 5) # start fully loaded
	guns.append(gun_data)
	
func get_current_gun() -> Dictionary:
	if guns.is_empty():
		return {}
	return guns[selected_gun_index]

func switch_gun(index: int):
	if index >= 0 and index < guns.size():
		selected_gun_index = index
		print("selected_gun", guns[selected_gun_index])

func add_coins(amount: int):
	coins += amount
	print("Global Coins: ", coins)

func get_coins() -> int:
	return coins
