@abstract class_name Chip extends Resource
## The abstract class for a chip, used for card modifications.

## The color of this chip.
@export var color:Color
## The name of this chip.
@export var name := ""
## How much this chip costs in the shop.
@export var cost := 20

## The info tooltip that shows when this chip's slot in the bar is hovered over.
@export_multiline() var info := ""

## The odds of this chip showing up in the shop.
# @export var weight := 1


## The texture this chip shows up as on the chip bar, and when held.
@export var texture:Texture2D

## Apply this chip's modifier to the card. 
## Optional hand argument to support things like 'copy the value of another card in the hand'
@abstract func apply(to:Card) -> void
