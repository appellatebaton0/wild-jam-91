class_name Randomizer extends Chip
## Sets to a random value.

func apply(to:Card) -> void: to.value = randi_range(1, 13)
