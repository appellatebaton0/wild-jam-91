class_name Table extends Control
## Manages the overall goings-ons of the Table screen's UI.

@onready var chip_bar    := %ChipBar        # The HBox holding the chips.
#@onready var score_lab   := %Score          # The label showing the score.
#@onready var money_lab   := %Money          # The label showing the money.
@onready var player_box  := %PlayerBox      # The box holding the players.
@onready var cont_button := %ContinueButton # The button to continue.
@onready var next_card   := %NextCard       # The next card to be dealt.
@onready var dealer_hand := %DealerHand     # The dealer's hand VBOX
@onready var turn_indic  := %TurnIndicator  # The indicator for who's turn it is.
@onready var ropopup     := %RoundOverPopup # The round over popup.

@export var anim_player:AnimationPlayer
@export var deal_sfx:AudioStreamPlayer

@export var players:Dictionary[StringName, Player] = {
	&"Player1": null
}

var deal_cycle:Array[StringName]
var deal_index := 0

func _ready() -> void:
	## Connect the signals.
	cont_button.pressed.connect(_on_next_pressed)
	
	Global.dealer_hand.new_card.connect(_on_new_card)
	Global.dealer_hand.cleared.connect(_on_clear_cards)
	
	for player in players:
		deal_cycle.append(player)
	deal_cycle.append(&"Dealer")
	
	deal_index = deal_cycle.find(&"Dealer")
	
	draw_new(true)

func _on_next_pressed() -> void:
	
	## Round's still going... Deal the current card to whoever it goes to.
	var target = deal_cycle[deal_index]
	
	if target == &"Dealer":
		var dealer_cards := Global.dealer_hand.cards
		if len(dealer_cards) > 0: 
			# Flip over any face down cards
			for card in dealer_cards: if not card.visible: card.visible = true
			
			var flipping_card := dealer_hand.get_child(len(dealer_cards) - 1)
			if flipping_card is CardNode:
				flipping_card.flipping = true
		
		Global.dealer_hand.deal(next_card.card, not len(Global.dealer_hand.cards) == 1)
		draw_new()
	else:
		target = players[target]
		if target is Player: # Deal the card to the player, face down if they're doubling down.
			
			match target.intent:
				Player.INTENT.HIT:
					target.hand.deal(next_card.card)
					target.renew_intent()
					draw_new()
				Player.INTENT.DOUBLE_DOWN:
					target.bet *= 2
					target.hand.deal(next_card.card, false)
					target.intent = Player.INTENT.STAND
					draw_new()
				_: ## Something went wrong.
					cycle_deal_index()
	
	## Cycle the dealing index.
	cycle_deal_index()
	
	## Check for any met round end conditions.
	
	var all_standing := true
	
	# Dealer is visibly winning.
	if Global.dealer_hand.is_winning():
		round_over()
		return
	
	# Is one of the players winning?
	for player in players.values():
		if player.hand.is_winning():
			round_over()
			return
		if not player.intent == Player.INTENT.STAND and not player.intent == Player.INTENT.OUT:
			all_standing = false
	
	# IF the dealer is over, all the players win.
	if Global.dealer_hand.is_over(): 
		round_over()
		return
	
	# IF all the players are standing or out, figure out who's won.
	
	if (all_standing and Global.dealer_hand.high() >= 17): 
		round_over()
		return
	
	## IF no chips remaining, just go again.
	for count in Global.chips.values(): if count > 0: return # If there are any chips left, cut.
	_on_next_pressed() # No more chips, go again

func cycle_deal_index() -> void: 
	var started_at := deal_index
	while true:
		
		
		
		# If the next player's intent is to HIT, it'll be their turn to draw, duh.
		if deal_cycle[deal_index] != &"Dealer" and players[deal_cycle[deal_index]].intent != Player.INTENT.STAND and players[deal_cycle[deal_index]].intent != Player.INTENT.OUT:
			break 
		
		if deal_cycle[deal_index] == &"Dealer" and len(Global.dealer_hand.cards) < 2:
			break ## If the dealer has less than two cards, keep drawing.
		
		# Cycle the deal index until a new valid target is found.
		deal_index = wrap(deal_index + 1, 0, len(deal_cycle))
		
		if deal_index == started_at:
			break # Looped around. The game's probably over.
		
		# If the dealer has an ace, and counting it as 11 would bring
		# the total to 17 or more (but not over 21), the dealer must 
		# count the ace as 11 and stand.
		
		# IE, if the HIGH is under 17, the dealer hits.
		
		if deal_cycle[deal_index] == &"Dealer" and Global.dealer_hand.high() < 17:
			break # The next turn belongs to the dealer.

func _process(_delta: float) -> void:
	var next := deal_cycle[deal_index]
	var next_node := dealer_hand if next == &"Dealer" else players[next].hand_box
	
	Global.next_hand = Global.dealer_hand if next == &"Dealer" else players[next].hand
	
	turn_indic.reparent(next_node)
	next_node.move_child(turn_indic, -1)

# Draw a new card into the dealer's hand.
func draw_new(muted := false) -> void:
	if deal_sfx and not muted: deal_sfx.play() # If we're getting a new card, one was dealt. Play that sound.
	
	var new = Card.new()
	new.value = randi_range(1, 12)
	
	next_card.card = new

func round_over():
	
	var round_data := get_round_data()
	ropopup.round_ended(players.values(), round_data["winners"], round_data["draws"], round_data["naturals"])
	
	deal_index = deal_cycle.find(&"Dealer")
	

	if anim_player: 
		anim_player.play("Table->EndPopup" if not Global.losing() else "RunEnded")

func get_round_data() -> Dictionary[String, Array]:
	## Figure out which players are currently beating the dealer.
	
	var response:Dictionary[String, Array] = {
		"winners": [],
		"draws": [],
		"naturals": [],
	}
	
	# The dealer's best value.
	var dealer_value = Global.dealer_hand.best()
	
	# Append any players who have a value that beats it.
	for player in players.values(): if player is Player:
		
		var best = player.hand.best()
		
		# Hand is 21, and dealer's isn't. Natural.
		if player.hand.is_winning() and not Global.dealer_hand.is_winning():
			response["naturals"].append(player)
		
		# If the player beats the player, or the dealer lost, they won.
		elif (player.hand.best() > dealer_value) or Global.dealer_hand.is_over():
			response["winners"].append(player)
		
		# Player draws w/ dealer.
		elif (player.hand.best() == dealer_value):
			response["draws"].append(player)
	
	return response
	
	#var best_player:Player = null
	#var best_distance:int
	#for player in players.values(): if player is Player:
		#if player.intent == Player.INTENT.OUT: continue # Skip losing players.
		#
		#if best_player == null or best_distance > abs(player.hand.closest() - 21):
			#best_player = player
			#best_distance = abs(player.hand.closest() - 21)

func get_naturals() -> Array[Player]:
	var response:Array[Player]
	
	for player in players.values(): if player is Player:
		if player.hand.is_winning(): response.append(player)
	
	return response

## Update the dealer's hand when it changes.

const CARD_NODE_SCENE := preload("res://Scenes/CardNode.tscn")
## Add a new card to the hand.
func _on_new_card(card:Card):
	
	var new:CardNode = CARD_NODE_SCENE.instantiate()
	new.card = card
	
	dealer_hand.add_child(new)

## Remove all the cards from the hand.
func _on_clear_cards(_cards:Array[Card]):
	for child in dealer_hand.get_children(): if child is CardNode:
		child.queue_free()
	
	
	
	# Shhh, we're just gonna sneak randomizing the player textures in here too. Nobody needs to know. Our secret.
	var bag = range(4)
	for player in players.values(): if player is Player:
		
		if len(bag) == 0: bag = range(4)
		
		player.texture.play(str(bag.pop_at(randi_range(0, len(bag) - 1))))
		player.intent_rect.position = player.texture.position - Vector2(0, 147)

func end_game() -> void: Global.end_game()
