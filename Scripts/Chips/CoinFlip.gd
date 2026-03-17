class_name CoinFlip extends Chip
## 50% chance to become an Ace, 50% chance to become a King

func apply(to:Card) -> void: to.value = 1 if randf() > 0.5 else 13
