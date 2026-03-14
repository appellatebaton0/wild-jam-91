class_name CardNode extends TextureRect
## Handles turning the card node into something readable.

@export var card:Card

var belongs_to:Hand ## The hand this card belongs to.

@export var modifiable := false ## Whether a token can be dragged onto this card.

var lab:Label
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# debug label.
	lab = Label.new()
	add_child(lab)

func _process(delta: float) -> void: if card:
	lab.text = str(card.value)

func _on_mouse_entered() -> void: Global.hovered_card = self
func _on_mouse_exited()  -> void: if Global.hovered_card == self: Global.hovered_card = null
