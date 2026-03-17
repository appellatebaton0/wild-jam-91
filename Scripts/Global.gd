extends Control
## All the necessary globals for the game. Mostly dealer data.

signal game_ended
signal run_ended

signal chips_changed(to:Array[Chip]) ## Emitted when the dealer's chips change.

var total_score := 0 ## The score of all games combined
var game_score := 0 ## The score for the current game.

var game_count := 0 ## The current game count.

var quota := 0 ## The quota for the current game.

var money := 60 ## How much money the player has.

var selected_shop_item:ShopEntry

const MAX_CHIP_SLOTS = 5

var dealer_hand := Hand.new()

var chips:Dictionary[Chip, int]: ## The chips the player has.
	set(to):
		chips = to
		chips_changed.emit(chips)
		
		print("!")

var held_chip:ChipNode:  ## The currently held chip, if any.
	set(to):
		held_chip = to
		if to: # Update the offset.
			held_offset = get_global_mouse_position() - held_chip.global_position
var held_offset:Vector2 ## The offset of the chip on the mouse.

var hovered_card:CardNode ## The current CardNode being hovered over, if any.

## End the current game. Ran before entering the shop.
func end_game():
	total_score += game_score
	game_score = 0
	game_count += 1
	
	dealer_hand.clear()
	
	game_ended.emit()

## End the current run. Ran when the dealer doesn't meet quota.
func end_run():
	money = 0
	game_score = 0
	game_count = 0
	total_score = 0
	chips.clear()
	run_ended.emit()
