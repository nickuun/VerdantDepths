extends HBoxContainer  # or whatever node it is

signal tool_selected(tool_type: String)

@onready var player: Node = null

func _ready():
	player = get_tree().get_first_node_in_group("player")

	for child in get_children():
		if child.has_signal("tool_selected"):
			child.connect("tool_selected", Callable(self, "_on_child_tool_selected"))

func _on_child_tool_selected(tool_type: String):
	# 🔁 Pass signal to others (like PlantSelector)
	emit_signal("tool_selected", tool_type)
	# 🎮 Assign to player
	player.current_tool = DataTypes.Tools[tool_type]

	print("Selected tool:", tool_type)
