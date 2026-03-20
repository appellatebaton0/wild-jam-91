class_name Hand extends Resource
## The class for the player / dealer's hand of cards.

signal new_card(card:Card)
signal cleared(hand:Array[Card])

var cards:Array[Card]

## Deal a new card into this hand.
func deal(card:Card, visible := true) -> bool:
	if cards.has(card): return false
	
	cards.append(card)
	card.visible = visible
	new_card.emit(card)
	
	return true

## Clear this hand of all its cards.
func clear() -> void:
	cleared.emit(cards)
	cards.clear()

## Whether the current hand is winning or not
func is_winning(visible_only := false) -> bool: return (high(visible_only) == 21) or (low(visible_only) == 21)

## Returns whichever, of the high and low, is closer to 21.
func closest(visible_only := false) -> int:
	var h = high(visible_only)
	var l = low(visible_only)
	return h if abs(h - 21) < abs(l - 21) else l 

func best(visible_only := false) -> int:
	var h = high(visible_only)
	var l = low(visible_only)
	return l if h > 21 else h

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
