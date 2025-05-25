extends Control

@export var animation_duration := 0.3
@export var crop_name := "Carrot"
@export var plant_names := ["Carrot", "Potato", "Radish", "Onion", "Beetroot", "Lettuce"]
@onready var button_container := $ButtonContainer
@onready var button_template := $ButtonContainer/PlantButton

var is_open := false

func _ready():
	hide()
	var toolbar = self.get_parent()  # 👈 adjust this path to your scene
	if toolbar:
		toolbar.connect("tool_selected", Callable(self, "_on_tool_selected"))
		
		# Dynamically create buttons
	button_template.visible = false  # Hide the original
	for name in plant_names:
		var new_button = button_template.duplicate()
		new_button.visible = true
		new_button.name = name
		new_button.connect("pressed", Callable(self, "_on_plant_button_pressed").bind(name))
		new_button.get_child(0).play(name)
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
	animate_slide(Vector2(20, 0.5))  # on-screen position

func close():
	is_open = false
	animate_slide(Vector2(-400, 0.5))  # off-screen

func animate_slide(target_pos: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, animation_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_plant_button_pressed(plant_name: String):
	GameState.current_plant_name = plant_name
	print("selected new plant:", plant_name)
	close()
