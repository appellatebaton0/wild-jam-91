class_name CardNode extends TextureRect
## Handles turning the card node into something readable.

@export var card:Card

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void: Global.
func _on_mouse_exited()  -> void: pas
