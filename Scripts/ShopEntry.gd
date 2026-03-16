class_name ShopEntry extends TextureRect
## Fully-contained shopfront for a single kind of chip.

@export var chip:Chip ## The chip being sold.
@export var cost:int  ## How much it costs.

@onready var buy := %Buy

func _ready() -> void: 
	buy.pressed.connect(_on_pressed)
	
	if chip:
		$MarginContainer/VBoxContainer/Texture.texture = chip.texture

func _process(_delta: float) -> void:
	buy.disabled = Global.money < cost

func _on_pressed() -> void: 
	
	if Global.money < cost:
		$Fail.play()
	
	elif empty_slot():
		$Suceed.play()
		
		if Global.chips.has(chip):
			Global.chips[chip] += 1
		else:
			Global.chips[chip] = 1
		Global.chips_changed.emit(Global.chips)
		
		print("Bought")
		
	else:
		$Fail.play()

## Returns if the bar has an empty slot, clearing a space if needed and possible.
func empty_slot() -> bool:
	if len(Global.chips.keys()) < Global.MAX_CHIP_SLOTS: return true
	
	for key in Global.chips:
		# Found an empty slot - erase its contents, return true.
		if Global.chips[key] == 0:
			Global.chips.erase(key)
			return true
	
	return false

## Custom Tooltippin'
func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip = preload("res://Scenes/Tooltip.tscn").instantiate()
	tooltip.text = for_text
	return tooltip

func _get_tooltip(_at_position: Vector2) -> String:
	
	var response = tooltip_text
	
	response = response.replace("{color}", chip.color.to_html())
	response = response.replace("{name}", chip.name)
	response = response.replace("{description}", chip.info)
	response = response.replace("{cost}", str(cost))
	
	return response
