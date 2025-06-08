extends HBoxContainer  # Or whatever the Toolbar is

signal tool_selected(tool_type: String)

func _ready():
	for child in get_children():
		if child.has_signal("tool_selected"):
			child.connect("tool_selected", Callable(self, "_on_child_tool_selected"))

func _on_child_tool_selected(tool_type: String):
	print("Toolbar emitting tool_selected:", tool_type)  # 🆕 Debug!
	emit_signal("tool_selected", tool_type)
