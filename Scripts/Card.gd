class_name Card extends Resource
## The class for all cards.

signal value_changed(from:int, to:int)

var value:int:
	set(to):
		value_changed.emit(value, to)
		
		# Set the value to its new one.
		value = to

## Return the lowest available / highest available real value for this card's value.
func low() -> int: return clamp(value, 1, 10) # clamp to 10, since face cards will be higher.
func high() -> int: return 11 if value == 1 else clamp(value, 1, 10)
