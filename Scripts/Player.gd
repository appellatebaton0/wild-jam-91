class_name Player extends Control
## The class that encompasses and manages each player in the game.

@onready var intent_rect := %Intent     ## The TextureRect to show intent.
@onready var hand_box    := %PlayerHand ## The VBox holding the hand.

enum INTENT {HIT, STAND, OUT, DOUBLE_DOWN}
@export var intent := INTENT.HIT
@export var hand := Hand.new() ## The player's hand

@export_range(2, 500) var bet:int = 50

@onready var lab := Label.new()
func _ready() -> void:
	hand.new_card.connect(_on_new_card)
	hand.cleared.connect(_on_clear_cards)
	Global.game_ended.connect(_on_game_end)
	
	renew_bet()
	
	# debug label
	add_child(lab)
func _process(delta: float) -> void: lab.text = str(intent)

const CARD_NODE_SCENE := preload("res://Scenes/CardNode.tscn")
## Add a new card to the hand.
func _on_new_card(card:Card):
	
	var new:CardNode = CARD_NODE_SCENE.instantiate()
	new.card = card
	
	hand_box.add_child(new)

## Remove all the cards from the hand.
func _on_clear_cards(_cards:Array[Card]):
	for child in hand_box.get_children():
		child.queue_free()

## Change the intent to whatever it should be now.
func renew_intent() -> INTENT:
	
	## If already standing or out, continue.
	if intent == INTENT.STAND or intent == INTENT.OUT: return intent
	
	## If over 21, out.
	if hand.low() > 21: 
		intent = INTENT.OUT
		return intent
	
	## Otherwise, make a choice based on the high and low scores, and the dealer's hand,
	## + A little randomness for flavor.
	## This is a simplification of https://en.wikipedia.org/wiki/Blackjack#Basic_strategy's chart.
	
	var high = hand.high()
	var low = hand.low()
	## The chance to double down, if possible.
	var double_chance:float = clamp((float(Global.game_count) / 10) - 1, 0, 0.8)
	
	## Whether or not this hand has an ace in it.
	var soft = high != low
	
	# IF the player's hand is hard
	if not soft:
		# Stand if can be over 16
		if high > 16: return set_intent(INTENT.STAND	, 0.07)
		
		# If between 12-16, hit if the dealer is over 6, otherwise stand.
		if high > 11 and high < 17:
			return set_intent(INTENT.HIT if Global.dealer_hand.high(true) > 6 else INTENT.STAND, 0.13)
		
		# If between 10-11, try to double down, and hit otherwise.
		if high > 9 and high < 12:
			return set_intent(INTENT.DOUBLE_DOWN if randf() <= double_chance else INTENT.HIT, 0.05, INTENT.HIT)
		
		# If under 10, hit.
		return set_intent(INTENT.HIT, 0.03)
	
	# IF the player's hand is soft;
	else:
		# Stand if the soft is 9-10 (aka 19-20)
		if low >= 9: return set_intent(INTENT.STAND, 0.07)
		
		var deal_high = Global.dealer_hand.high(true)
		if low == 8:
			
			# If the dealer's high is 9+, hit.
			if deal_high >= 9: return set_intent(INTENT.HIT, 0.07)
			# 7-8, stand.
			if deal_high > 6 and deal_high < 9: return set_intent(INTENT.STAND, 0.07)
			# 2-6, double-down stand.
			return set_intent(INTENT.DOUBLE_DOWN if randf() <= double_chance else INTENT.STAND, 0.05, INTENT.STAND)
		
		# IF the dealer's too high, hit.
		if deal_high > 6: return set_intent(INTENT.HIT, 0.05)
		
		# Otherwise, double down depending on some stuff. idrk man.
		var double_down = randf() <= double_chance and (7-low) - (deal_high * 2) <= -6
		return set_intent(INTENT.DOUBLE_DOWN if double_down else INTENT.HIT, 0.05, INTENT.HIT)

## Sets the intent to [to], with a chance to randomize it.
func set_intent(to:INTENT, randomize_chance:float, randomize_def := intent) -> INTENT:
	intent = to
	if randf() <= randomize_chance: invert_intent(randomize_def)
	
	return intent

## Switches the intent to the opposite of what it was,
## With a default for if there's no clear opposite.
func invert_intent(def := intent):
	match intent:
		INTENT.STAND: intent = INTENT.HIT
		INTENT.HIT: intent = INTENT.STAND
		_:
			intent = def

func renew_bet() -> int:
	bet = randi_range(50, 500)
	return bet

## When the current game ends, reset the hand and the bet.
func _on_game_end() -> void:
	
	hand.clear()
	renew_bet()
	intent = INTENT.HIT
