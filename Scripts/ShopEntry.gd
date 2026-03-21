class_name ShopEntry extends Control
## Fully-contained shopfront for a single kind of chip.

@export var chip:Chip ## The chip being sold.

@onready var tooltip_original := tooltip_text

@onready var chip_texture := %ChipTexture
@onready var highlight := %Highlight

var mouse_over := false

func mouse_enter() -> void: mouse_over = true
func mouse_exit()  -> void: mouse_over = false

const HIGHLIGHT_TEXTURE := preload("res://Assets/Chips/ChipHighlight.png")

func _ready() -> void: 
	chip_texture.pressed.connect(_on_pressed)
	chip_texture.mouse_entered.connect(mouse_enter)
	chip_texture.mouse_exited.connect(mouse_exit)

func _process(_delta: float) -> void: if chip:
	
	chip_texture.texture_normal = chip.texture if open() else null
	chip_texture.disabled = Global.money < chip.cost and open()
	$Highlight/ChipTexture/Label.text = ("$" + str(chip.cost)) if open() else ""
	
	highlight.texture = HIGHLIGHT_TEXTURE if (mouse_over and open()) or Global.selected_shop_item == self else null

func _on_pressed() -> void: if open(): 
	Global.selected_shop_item = self
	$AudioStreamPlayer.play()

@warning_ignore("integer_division")
func open() -> bool: return get_index() <= (Global.round_count / 3)

## Custom Tooltippin'
func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip = preload("res://Scenes/Tooltip.tscn").instantiate()
	tooltip.text = for_text
	return tooltip

func _get_tooltip(_at_position: Vector2) -> String:
	
	if not chip or not open(): return "" 
	
	var response = tooltip_text
	
	response = response.replace("{color}", chip.color.to_html())
	response = response.replace("{name}", chip.name)
	response = response.replace("{description}", chip.info)
	response = response.replace("{cost}", str(chip.cost))
	
	return response
