@abstract class_name Chip extends Node
## The abstract class for a chip, used for card modifications.

signal used ## Emitted when a chip is used on a card.
signal dropped ## Emitted when a held chip is let go of outside a card - returns to its appropriate stack.

## Apply this chip's modifier to the card. 
## Optional hand argument to support things like 'copy the value of another card in the hand'
@abstract func apply(to:Card, _of:Hand = null) -> void
