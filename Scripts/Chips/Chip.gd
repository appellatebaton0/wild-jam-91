@abstract class_name Chip extends Resource
## The abstract class for a chip, used for card modifications.

signal used ## Emitted when a chip is used on a card.
signal dropped ## Emitted when a held chip is let go of outside a card - returns to its appropriate stack.

## The odds of this chip showing up in the shop.
@export var weight := 1
## The tooltip that shows when this chip's slot in the bar is hovered over.
@export_multiline() var tooltip := ""

## Apply this chip's modifier to the card. 
## Optional hand argument to support things like 'copy the value of another card in the hand'
@abstract func apply(to:Card, _of:Hand = null) -> void
