class_name CardNode extends TextureRect
## Handles turning the card node into something readable.

const TEXTURE_DICT := {
	false: {
		true: preload("res://Assets/Cards/RegularCard.png"),
		false: preload("res://Assets/Cards/Back.png")
	},
	true: {
		true: preload("res://Assets/Cards/EvilCard.png"),
		false: preload("res://Assets/Cards/Back.png")
	}
}
@onready var label := $Label

@export var FLIP_SPEED := 350

var flipping = false

@onready var start_pos := global_position

@export var max_x := 48.0
@export var card:Card:
	set(to):
		if card:
			card.value_changed.disconnect(flip)
		
		card = to
		card.value_changed.connect(flip)
		
		flip()

var belongs_to:Hand ## The hand this card belongs to.

@export var modifiable := false ## Whether a token can be dragged onto this card.

var lab:Label
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	if card:
		_update_texture()

func _process(delta: float) -> void:
	if flipping:
		custom_minimum_size.x = move_toward(custom_minimum_size.x, 0, delta * FLIP_SPEED)
		if custom_minimum_size.x == 0:
			_update_texture()
			flipping = false
	else:
		custom_minimum_size.x = move_toward(custom_minimum_size.x, max_x, delta * FLIP_SPEED)
	
	if label:
		label.add_theme_font_size_override("font_size", custom_minimum_size.x / 1.2)
	
	if modifiable:
		size.x = custom_minimum_size.x
		global_position = start_pos - Vector2(custom_minimum_size.x / 2,0)

func _update_texture(_a = null): 
	texture = TEXTURE_DICT[card.modified][card.visible or modifiable]
	label.text = card.character()
	label.visible = (card.visible or modifiable)
func flip(): flipping = true

func _on_mouse_entered() -> void: Global.hovered_card = self
func _on_mouse_exited()  -> void: if Global.hovered_card == self: Global.hovered_card = null
