class_name DoubleChip extends Chip
## Doubles the value of the card it's applied to.

func apply(to:Card) -> void:
	
	to.value *= 2
	pass
