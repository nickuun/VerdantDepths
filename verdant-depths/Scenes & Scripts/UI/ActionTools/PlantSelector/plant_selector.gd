extends Control

@export var animation_duration := 0.3
@export var crop_name := "carrot"
@export var plant_names := ["carrot", "potato", "radish", "onion", "beetroot", "lettuce", "pumpkin"]
@onready var button_container := $ButtonContainer
@onready var button_template := $ButtonContainer/PlantButton

var is_open := false

func _ready():
	hide()
	var toolbar = self.get_parent().get_parent()
	if toolbar:
		print("✅ PlantSelector connected to Toolbar")
		toolbar.connect("tool_selected", Callable(self, "_on_tool_selected"))


	button_template.visible = false  # Hide template
	update_crop_buttons()

func _on_tool_selected(tool_type):
	print("Tool selected:", tool_type)
	if tool_type == "Plant":
		if is_open:
			close()
		else:
			open()
	else:
		if is_open:
			close()

func open():
	print("open")
	update_crop_buttons()

	# Calculate how many rows of buttons there will be
	var total_buttons := 0
	for crop in InventoryManager.crop_ammo.keys():
		if InventoryManager.has_seen_crop(crop):
			total_buttons += 1

	var columns = button_container.columns
	var rows := int(ceil(total_buttons / float(columns)))
	var y_offset := -27 - ((rows - 1) * 20)  # each row above the first pushes up 20px

	show()
	is_open = true
	animate_slide(Vector2(0, y_offset))

func close():
	print("close")
	is_open = false
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0.5, 26), animation_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(Callable(self, "hide"))


func animate_slide(target_pos: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, animation_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_plant_button_pressed(plant_name: String):
	GameState.current_plant_name = plant_name
	print("selected new plant:", plant_name)
	close()

func update_crop_buttons():
	# Clear all buttons except the template
	for child in button_container.get_children():
		if child != button_template:
			child.queue_free()

	var crops := []
	for crop in InventoryManager.crop_ammo.keys():
		if not InventoryManager.has_seen_crop(crop):
			continue
		var amount = InventoryManager.get_crop_ammo(crop)
		var enabled = amount > 0
		crops.append({ "name": crop, "amount": amount, "enabled": enabled })

	# Sort crops: enabled first, then by amount descending
	crops.sort_custom(func(a, b):
		if a.enabled != b.enabled:
			return a.enabled > b.enabled  # true before false
		return a.amount > b.amount  # higher first
	)

	for entry in crops:
		var crop = entry.name
		var new_button = button_template.duplicate()
		new_button.visible = true
		new_button.name = crop
		new_button.connect("pressed", Callable(self, "_on_plant_button_pressed").bind(crop))
		new_button.get_child(0).animation = crop
		new_button.get_child(0).frame = 4

		new_button.disabled = not entry.enabled
		new_button.modulate = Color(1, 1, 1, 1) if entry.enabled else Color(1, 1, 1, 0.4)

		button_container.add_child(new_button)

func _unhandled_input(event):
	if is_open and event is InputEventMouseButton and event.pressed:
		if not get_global_rect().has_point(get_global_mouse_position()):
			close()
