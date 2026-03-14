class_name ChipNode extends TextureRect
## The instance of a chip meant to be dragged onto a card. 

var from:ChipSlot

@export var chip:Chip: ## The chip this node is.
	set(to):
		if to == chip: return
		
		chip = to
		
		texture = chip.texture

func _on_dropped() -> void: pass
func _on_pickup() -> void: pass

func _input(event: InputEvent) -> void:
	print(event.position)
	if Global.held_chip == self:
		if event is InputEventMouse:
			global_position = get_global_mouse_position() - Global.held_offset
