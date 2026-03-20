class_name WindowSetter extends OptionButton

var mode:Dictionary[int, DisplayServer.WindowMode] = {
	0: DisplayServer.WINDOW_MODE_WINDOWED,
	1: DisplayServer.WINDOW_MODE_MINIMIZED,
	2: DisplayServer.WINDOW_MODE_MAXIMIZED,
	3: DisplayServer.WINDOW_MODE_FULLSCREEN,
	4: DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,
}

var disp:Dictionary[int, String] = {
	0: "Windowed",
	1: "Minimized",
	2: "Maximized",
	3: "Fullscreen",
	4: "Exclusive Fullscreen"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for option in disp.values():
		add_item(option)
	selected = DisplayServer.window_get_mode()
	
	item_selected.connect(_item_selected)

func _item_selected(index:int):
	DisplayServer.window_set_mode(mode[index])
