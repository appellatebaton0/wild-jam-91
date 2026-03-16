class_name ShopEntry extends Control
## Fully-contained shopfront for a single kind of chip.

@export var chip:Chip ## The chip being sold.
@export var cost:int  ## How much it costs.

@onready var chip_texture := %ChipTexture

func _ready() -> void: 
	chip_texture.pressed.connect(_on_pressed)
	
	if chip:
		chip_texture.texture_normal = chip.texture

func _process(_delta: float) -> void:
	chip_texture.disabled = Global.money < cost

func _on_pressed() -> void: Global.selected_shop_item = self
	
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
