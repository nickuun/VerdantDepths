extends TextureButton

@export var tool_type: String = "dig"

signal tool_selected(tool_type: String)

const TOOL_ICONS := {
	"Attack": "res://Sprites/UI/Icons/sword.png",
	"Plant":  "res://Sprites/UI/Icons/plan alt.png",
	"Dig":    "res://Sprites/UI/Icons/shovel.png",
	"Water":  "res://Sprites/UI/Icons/water.png"
}

func _ready():
	connect("pressed", Callable(self, "_on_pressed"))
	_update_icon()

func _on_pressed():
	print("PRESSED:", tool_type)
	emit_signal("tool_selected", tool_type)

func _update_icon():
	if TOOL_ICONS.has(tool_type):
		var icon_path = TOOL_ICONS[tool_type]
		$Sprite2D.texture = load(icon_path)
	else:
		print("⚠️ Unknown tool_type:", tool_type)
