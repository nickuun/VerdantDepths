class_name GameInputEvents
static var direction: Vector2
#static var last_direction

static func movement_input() -> Vector2:
	direction = Input.get_vector("left", "right", "up", "down")
	#last_direction = direction
	return direction

static func is_momement_input() -> bool:
	if direction == Vector2.ZERO:
		return false
	else:
		return true

static func use_tool():
	var use_tool_value: bool = Input.is_action_pressed("click") or Input.is_action_just_pressed("click")
	return use_tool_value

static func dodge_pressed() -> bool:
	return Input.is_action_just_pressed("dodge")

static func melee_pressed() -> bool:
	return Input.is_action_just_pressed("melee_attack")
