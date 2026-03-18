class_name Shop extends Control

@onready var cont_button := %Continue
@onready var buy_button := %BuyButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cont_button.pressed.connect(_on_continue)
	buy_button.pressed.connect(_on_buy)

func _process(_delta: float) -> void:
	buy_button.disabled = not Global.selected_shop_item or Global.money < Global.selected_shop_item.chip.cost

func _on_continue(): Global.end_game()

func _on_buy():
	
	if Global.money < Global.selected_shop_item.chip.cost:
		$Fail.play()
	
	elif empty_slot():
		$Suceed.play()
		
		if Global.chips.has(Global.selected_shop_item.chip):
			Global.chips[Global.selected_shop_item.chip] += 1
		else:
			Global.chips[Global.selected_shop_item.chip] = 1
		Global.chips_changed.emit(Global.chips)
	else:
		$Fail.play()

## Returns if the bar has an empty slot, clearing a space if needed and possible.
func empty_slot() -> bool:
	if len(Global.chips.keys()) < Global.MAX_CHIP_SLOTS: return true
	
	for key in Global.chips:
		# Found an empty slot - erase its contents, return true.
		if Global.chips[key] == 0:
			Global.chips.erase(key)
			return true
	
	return false
