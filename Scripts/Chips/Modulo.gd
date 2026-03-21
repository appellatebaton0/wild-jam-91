class_name Modulo extends Chip
## If odd, become a random odd value. If even, a random even value.

func apply(to:Card) -> void:
	
	if to.value % 2: # IF is odd:
		to.value = [1, 3, 5, 7, 9].pick_random()
	else:
		to.value = [2, 4, 6, 8, 10].pick_random()
	# What, you thought I was going to do cool math? No. I'm tired.
	# Prob just randi_range(1,5) * 2 for even, then -1 for odd.
