class_name CardNode extends TextureRect
## Handles turning the card node into something readable.

const FLIP_SPEED := 500

var flipping = false

@export var card:Card:
	set(to):
		if card:
			card.value_changed.disconnect(_update_texture)
		
		card = to
		card.value_changed.connect(_update_texture)
		
		_update_texture()

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
		custom_minimum_size.x = move_toward(custom_minimum_size.x, 48, delta * FLIP_SPEED)

func _update_texture(_a = null): texture = card.texture(modifiable)

func _on_mouse_entered() -> void: Global.hovered_card = self
func _on_mouse_exited()  -> void: if Global.hovered_card == self: Global.hovered_card = null
