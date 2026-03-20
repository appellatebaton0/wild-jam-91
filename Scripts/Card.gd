class_name Card extends Resource
## The class for all cards.

signal value_changed(to:int)
signal visibility_changed(to:bool)
signal got_modified

var modified := false: ## Whether this card has been modified by a chip.
	set(to):
		if to: got_modified.emit()
		modified = to

## If the card is face up or not.
@export var visible := false:
	set(to):
		visibility_changed.emit(to)
		visible = to

@export var value:int:
	set(to):
		to = clamp(to, 1, 13)
		
		value_changed.emit(to)
		
		# Set the value to its new one.
		value = to

## Return the lowest available / highest available real value for this card's value.
func low() -> int: return clamp(value, 1, 10) # clamp to 10, since face cards will be higher.
func high() -> int: return 11 if value == 1 else clamp(value, 1, 10)

func name() -> String: return ["", "Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"][value]
