extends Control

@export var animation_duration := 0.3
@export var crop_name := "carrot"
@export var plant_names := ["carrot", "potato", "radish", "onion", "beetroot", "lettuce", "pumpkin"]
@onready var button_container := $ButtonContainer
@onready var button_template := $ButtonContainer/PlantButton

var is_open := false

func _ready():
	hide()
	var toolbar = self.get_parent()
	if toolbar:
		toolbar.connect("tool_selected", Callable(self, "_on_tool_selected"))

	button_template.visible = false  # Hide template

	for crop in InventoryManager.crop_ammo.keys():
		if not InventoryManager.has_seen_crop(crop):
			continue  # Skip crops never seen before

		var new_button = button_template.duplicate()
		new_button.visible = true
		new_button.name = crop
		new_button.connect("pressed", Callable(self, "_on_plant_button_pressed").bind(crop))
		new_button.get_child(0).play(crop)

		var has_ammo = InventoryManager.get_crop_ammo(crop) > 0
		new_button.disabled = not has_ammo
		new_button.modulate = Color(1, 1, 1, 1) if has_ammo else Color(1, 1, 1, 0.4)

		button_container.add_child(new_button)

func _on_tool_selected(tool_type):
	print("Tool selected:", tool_type)
	if tool_type == "Plant":
		open()
	else:
		if is_open:
			close()

func open():
	show()
	is_open = true
	animate_slide(Vector2(0, -27))  # on-screen position

func close():
	is_open = false
	animate_slide(Vector2(0.5, 26))  # off-screen

func animate_slide(target_pos: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, animation_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_plant_button_pressed(plant_name: String):
	GameState.current_plant_name = plant_name
	print("selected new plant:", plant_name)
	close()
