extends Control

@onready var player  # Adjust as needed

func _ready():
	player = self.get_tree().get_first_node_in_group("player")
	for child in self.get_children():
		child.connect("tool_selected", Callable(self, "_on_tool_selected"))

func _on_tool_selected(tool_type: String):
	player.current_tool = DataTypes.Tools[tool_type]
	print("Selected tool: ", tool_type)
