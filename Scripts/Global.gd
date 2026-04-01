extends Control
## All the necessary globals for the game. Mostly dealer data.

signal game_ended
signal run_ended

signal chips_changed(to:Array[Chip]) ## Emitted when the dealer's chips change.

var round_count := 0 ## The current game count.

var chips_used := 0 ## How many chips have been used this run.

var total_income := 0
var total_expenses := 0

var show_total_tooltips := false
var fast_forward_on_empty := false

var money := 60: ## How much money the player has.
	set(to):
		if to > money:
			total_income += to - money
		elif to < money:
			total_expenses += money - to
		
		money = to
var bank := 450: ## How much money the casino bank has.
	set(to):
		
		if to > bank:
			total_income += to - bank
		elif to < bank:
			total_expenses += bank - to
		
		if to < 0:
			money += to
			bank = 0
		else:
			bank = to

var selected_shop_item:ShopEntry

const MAX_CHIP_SLOTS = 5

## The dealer's (player's) hand.
var dealer_hand := Hand.new()
## The hand the next card is going into.
var next_hand:Hand

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

func losing() -> bool:
	return bank <=0 and money <= 0

## End the current game. Ran before entering the shop.
func end_game():
	round_count += 1
	
	dealer_hand.clear()
	
	game_ended.emit()

## End the current run. Ran when the dealer goes bankrupt.
@onready var starting_money := money 
@onready var starting_bank := bank 
func end_run():
	money = starting_money
	bank = starting_bank
	round_count = 0
	chips.clear()
	run_ended.emit()
	chips_used = 0
	
	total_income = 0
	total_expenses = 0
