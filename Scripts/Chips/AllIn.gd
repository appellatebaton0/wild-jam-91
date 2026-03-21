class_name AllIn extends Chip
## 50% Chance to become the best possible value (ie, whatever's needed to hit 21, or an Ace), 50% chance to become the worst possible card (10 if that breaks 21, otherwise a low value).

func apply(to:Card) -> void: to.value = find_best_value() if randf() > 0.5 else find_worst_value()

func find_best_value() -> int:
	var from := Global.next_hand
	
	var h = 21 - from.high()
	var l = 21 - from.low()
	
	# If the hand is 11 or less away from 21, there's a viable answer.
	if l <= 11: return l if l != 11 else 1
	if h <= 11: return h if h != 11 else 1 # Edge case, if the dist is 11 return an Ace
	
	return 1 # Otherwise, return an ace.

func find_worst_value() -> int:
	var from := Global.next_hand
	
	var l = from.low()
	
	if l > 11: return 13 # If can be pushed over 21, do that.
	
	if l > 10: return 1 # If an ace pushes it over (and is therefore worth 1), return that
	
	return 2 # Otherwise, return two
