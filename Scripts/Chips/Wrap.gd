class_name Wrap extends Chip
## Adds 3 to the value, and wraps it around 10.

func apply(to:Card) -> void: to.value = wrap(to.value + 3, 1, 11)
