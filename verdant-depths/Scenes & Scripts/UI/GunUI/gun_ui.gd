extends Control

@onready var reserve_label = $ReserveAmmoLabel
@onready var gun_icon = $GunIcon
@onready var crop_icon_template = $CropIconTemplate
var crop_icons: Array = []

func _process(_delta):
	var gun_data = InventoryManager.get_current_gun()
	var crop_type = gun_data.get("crop_type")
	reserve_label.text = str(InventoryManager.get_crop_ammo(crop_type))

func update_ui():
	var gun_data = InventoryManager.get_current_gun()

	# Play gun icon animation
	gun_icon.play(gun_data.get("crop_type", "carrot"))

	# Clear old crop icons
	for icon in crop_icons:
		icon.queue_free()
	crop_icons.clear()

	# Rebuild crop clip visuals
	var clip_size = gun_data.get("clip_size", 5) 
	
	print("clip_size is ", clip_size)
	for i in range(clip_size):
		var icon = crop_icon_template.duplicate()
		icon.visible = true
		icon.position = crop_icon_template.position + Vector2(i * 10, 0)
		add_child(icon)
		crop_icons.append(icon)

func update_clip_ammo(current_ammo: int):
	for i in range(crop_icons.size()):
		crop_icons[i].modulate.a = 1.0 if i < current_ammo else 0.2
