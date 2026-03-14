class_name Player extends Control
## The class that encompasses and manages each player in the game.

@onready var intent_rect := %Intent     ## The TextureRect to show intent.
@onready var hand_box    := %PlayerHand ## The VBox holding the hand.

enum INTENT {HIT, STAND, OUT}
@export var intent := INTENT.HIT
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

## Change the intent to whatever it should be now.
func renew_intent() -> void:
	
	## If already standing or out, continue.
	if intent == INTENT.STAND or intent == INTENT.OUT: return
	
	## If over 21, out.
	if hand.low() > 21: 
		intent = INTENT.OUT
		return 
	
	## Otherwise, make a choice based on the high and low scores, and the dealer's hand,
	## + A little randomness for flavor.
	
	# Stand if can be over 16
	if hand.high() > 16:
		intent = INTENT.STAND
		return
	
	
	
