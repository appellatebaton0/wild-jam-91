class_name Player extends Control
## The class that encompasses and manages each player in the game.

@onready var intent_rect := %Intent     ## The TextureRect to show intent.
@onready var hand_box    := %PlayerHand ## The VBox holding the hand.

@export var hand := Hand.new() ## The player's hand

func _ready() -> void:
	hand.new_card.connect(_on_new_card)
	hand.cleared.connect(_on_clear_cards)

## Add a new card to the visible hand.
func _on_new_card(card:Card):
	
	var new = CardNode.new()
	new.card = card
	
	hand_box.add_child(new)

## Remove all the cards from the hand.
func _on_clear_cards():
	for child in hand_box.get_children():
		child.queue_free()
