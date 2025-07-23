extends TextureRect

@export var mod_data: Dictionary = {}
var draggable = false

func _ready():
	#texture = preload("res://icons/%s.png" % mod_data.get("effect", "default"))
	tooltip_text = mod_data.get("name", "Unknown Mod")
	draggable = true

func get_drag_data(position):
	var drag_preview = TextureRect.new()
	drag_preview.texture = texture
	set_drag_preview(drag_preview)
	return {"mod_data": mod_data}

func can_drop_data(_pos, data):
	return false # we don’t accept drops here
