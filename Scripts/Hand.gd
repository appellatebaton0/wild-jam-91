class_name Hand extends Resource
## The class for the player / dealer's hand of cards.

signal new_card(card:Card)
signal cleared(hand:Array[Card])

var cards:Array[Card]

## Deal a new card into this hand.
func deal(card:Card) -> bool:
	if cards.has(card): return false
	
	cards.append(cards)
	new_card.emit(card)
	
	return true

## Clear this hand of all its cards.
func clear() -> void:
	cleared.emit(cards)
	cards.clear()

## Whether the current hand is winning or not
func is_winning() -> bool: return (high() == 21) or (low() == 21)

## Whether the current hand is losing.
func is_over() -> bool: return low() > 21

## The running high and low totals of the hand.
func high(visible_only := false) -> int:
	var total := 0
	for card in cards: if card.visible or not visible_only: total += card.high()
	return total
func low(visible_only := false) -> int:
	var total := 0
	for card in cards: if card.visible or not visible_only: total += card.low()
	return total
