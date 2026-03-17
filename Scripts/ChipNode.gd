class_name ChipNode extends TextureRect
## The instance of a chip meant to be dragged onto a card. 

signal dropped

var from:ChipSlot

@export var chip:Chip: ## The chip this node is.
	set(to):
		if to == chip: return
		
		chip = to
		
		texture = chip.texture

func _on_dropped() -> void: pass
func _on_pickup() -> void: pass

func _input(event: InputEvent) -> void:
	if Global.held_chip == self:
		if event is InputEventMouseButton: 
			if not event.pressed:
			
				var card = Global.hovered_card
				if card and card.modifiable:
					## Modify the hovered-over card, and delete this chip.
					if card.card: 
						card.card.modified = true
						if card.animator: card.animator.play("ignite")
						chip.apply(card.card)
						
					
					## Some particle effect before this?
					queue_free()
				else:
					## Dropped the chip D:
					dropped.emit()
					
					## Same thing w/ a particle effect of some sort.
					queue_free()
		elif event is InputEventMouse:
			global_position = get_global_mouse_position() - Global.held_offset
			
