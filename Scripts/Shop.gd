class_name Shop extends Control

@onready var cont_button := %Continue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cont_button.pressed.connect(_on_continue)


func _on_continue():
	Global.end_game()
