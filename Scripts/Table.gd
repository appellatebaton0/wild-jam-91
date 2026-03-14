class_name Table extends Control
## Manages the overall goings-ons of the Table screen's UI.

@onready var chip_bar    := %ChipBar        # The HBox holding the chips.
@onready var score_lab   := %Score          # The label showing the score.
@onready var money_lab   := %Money          # The label showing the money.
@onready var player_box  := %PlayerBox      # The box holding the players.
@onready var cont_button := %ContinueButton # The button to continue.
@onready var next_card   := %NextCard       # The next card to be dealt.
@onready var dealer_hand := %DealerHand     # The dealer's hand VBOX
var deal_hand := Hand.new()

@export var players:Dictionary[StringName, Player] = {
	&"Player1": null
}

var deal_cycle:Array[StringName]
var deal_index := 0

func _ready() -> void:
	## Connect the signals.
	Global.chips_changed.connect(_on_chips_changed)
	cont_button.pressed.connect(_on_next_pressed)
	
	for player in players:
		deal_cycle.append(player)
	deal_cycle.append(&"Dealer")

const CHIP_SLOT_SCENE := preload("res://Scenes/ChipSlot.tscn")
## Update the chips in the chip_bar to the new set.
func _on_chips_changed(to:Dictionary[Chip, int]) -> void:
	
	## Get rid of the existing chips.
	for child in chip_bar.get_children():
		child.queue_free()
	
	## Add in the new chips.
	for chip in to:
		var new:ChipSlot = CHIP_SLOT_SCENE.instantiate()
		
		new.chip = chip
		new.count = to[chip]
		
		chip_bar.add_child(new)

func _on_next_pressed() -> void:
	## Deal the current card to whoever it goes to, 
	print(deal_index)
	
	
	cycle_deal_index()

func cycle_deal_index() -> void: 
	while true:
		deal_index = wrap(deal_index + 1, 0, len(deal_cycle))
		
		if deal_cycle[deal_index] == &"Dealer" and 

## -- MANAGING DEALER's HAND -- ## 

func _on_new_
