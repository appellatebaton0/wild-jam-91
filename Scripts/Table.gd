class_name Table extends Control
## Manages the overall goings-ons of the Table screen's UI.

@onready var chip_bar    := %ChipBar        # The HBox holding the chips.
@onready var score_lab   := %Score          # The label showing the score.
@onready var money_lab   := %Money          # The label showing the money.
@onready var player_box  := %PlayerBox      # The box holding the players.
@onready var cont_button := %ContinueButton # The button to continue.
@onready var next_card   := %NextCard       # The next card to be dealt.

func _ready() -> void:
	## Connect the signals.
	pass

## Update the chips in the chip_bar to the new set.
func _on_chips_changed(to:Array[Chip]):
	
	pass
