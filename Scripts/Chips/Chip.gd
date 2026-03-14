@abstract class_name Chip extends Resource
## The abstract class for a chip, used for card modifications.

## The odds of this chip showing up in the shop.
@export var weight := 1
## The tooltip that shows when this chip's slot in the bar is hovered over.
@export_multiline() var tooltip := ""
## The texture this chip shows up as on the chip bar, and when held.
@export var texture:Texture2D

## Apply this chip's modifier to the card. 
## Optional hand argument to support things like 'copy the value of another card in the hand'
@abstract func apply(to:Card, _of:Hand = null) -> void
