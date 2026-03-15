class_name Card extends Resource
## The class for all cards.

signal value_changed
signal visibility_changed(to:bool)

## If the card is face up or not.
@export var visible := false:
	set(to):
		visibility_changed.emit(to)
		visible = to

@export var value:int:
	set(to):
		to = clamp(to, 1, 13)
		
		value_changed.emit()
		
		# Set the value to its new one.
		value = to

## Return the lowest available / highest available real value for this card's value.
func low() -> int: return clamp(value, 1, 10) # clamp to 10, since face cards will be higher.
func high() -> int: return 11 if value == 1 else clamp(value, 1, 10)

const TEXTURES := [
	preload("res://Assets/Cards/Ace.png"),
	preload("res://Assets/Cards/2.png"),
	preload("res://Assets/Cards/3.png"),
	preload("res://Assets/Cards/4.png"),
	preload("res://Assets/Cards/5.png"),
	preload("res://Assets/Cards/6.png"),
	preload("res://Assets/Cards/7.png"),
	preload("res://Assets/Cards/8.png"),
	preload("res://Assets/Cards/9.png"),
	preload("res://Assets/Cards/10.png"),
	preload("res://Assets/Cards/Jack.png"),
	preload("res://Assets/Cards/Queen.png"),
	preload("res://Assets/Cards/King.png"),
	preload("res://Assets/Cards/Back.png")]
func texture(override := false) -> Texture2D: 
	print(override, " -> ", value)
	return TEXTURES[value - 1] if visible or override else TEXTURES[13]
