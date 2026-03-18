class_name Duplicator extends Chip
## Duplicates the last card in the hand.

func apply(to:Card) -> void:
	
	var cards := Global.next_hand.cards
	
	if len(cards) > 0:
		to.value = cards.back()
	else:
		to.value = randi_range(1, 13)
	
	
	pass
