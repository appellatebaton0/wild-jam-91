class_name CardNode extends TextureRect
## Handles turning the card node into something readable.

@export var animator:AnimatedSprite2D
@export var change_sfx:AudioStreamPlayer
@export var flip_sfx:AudioStreamPlayer

const TEXTURE_DICT := {
	false: {
		true: preload("res://Assets/Cards/RegularCard.png"),
		false: preload("res://Assets/Cards/CardBack.png")
	},
	true: {
		true: preload("res://Assets/Cards/EvilCard.png"),
		false: preload("res://Assets/Cards/CardBack.png")
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
			if change_sfx:
				card.got_modified.disconnect(change_sfx.play)
		
		card = to
		card.value_changed.connect(flip)
		if change_sfx:
			card.got_modified.connect(change_sfx.play)
		
		flip(to.value)

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
		label.scale.x = custom_minimum_size.x / max_x
		label.pivot_offset.x = label.size.x / 2
		
		if out_of_date:
			label.text = character()
			label.visible = (card.visible or modifiable)
			out_of_date = false
	
	if modifiable:
		size.x = custom_minimum_size.x
		global_position = start_pos - Vector2(custom_minimum_size.x / 2,0)

var out_of_date := false
func _update_texture(to:int = card.value): 
	texture = TEXTURE_DICT[card.modified][card.visible or modifiable]
	if label:
		label.text = character(to)
		label.visible = (card.visible or modifiable)
	else:
		out_of_date = true
	
	if flip_sfx: flip_sfx.play()
	
func flip(to:int): 
	if not card.modified:
		flipping = true
	else:
		_update_texture(to)

func _on_mouse_entered() -> void: Global.hovered_card = self
func _on_mouse_exited()  -> void: if Global.hovered_card == self: Global.hovered_card = null

func character(for_val:int = card.value) -> String:
	match for_val:
		1: return "A"
		11: return "J"
		12: return "Q"
		13: return "K"
		_: return str(for_val)

## Custom Tooltippin'
func _make_custom_tooltip(for_text: String) -> Object:
	
	var tooltip = preload("res://Scenes/Tooltip.tscn").instantiate()
	tooltip.text = for_text
	
	return tooltip


func _get_tooltip(_at_position: Vector2) -> String:
	
	## Create the tooltip on the spot, from the base text in the property.
	
	var response:String = tooltip_text
	
	response = response.replace("{color}", "#E93816" if card.modified else "#5A9634")
	response = response.replace("{name}", card.name() if card.visible or modifiable else "??")
	response = response.replace("{value}", str(clamp(card.value, 2, 10) if card.value != 1 else "1 or 11") if card.visible or modifiable else "??")
	
	return response
