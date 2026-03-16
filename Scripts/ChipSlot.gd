class_name ChipSlot extends TextureRect
## Provides a control the player can interact with for a chip.

const EMPTY_TEXTURE:Texture2D = preload("res://Assets/Chips/EmptyChip.png")

@export var usable := true ## WHether this slot allows for its chip to be dragged out of it.

@export var chip:Chip: ## The chip this node is.
	set(to):
		
		chip = to
		
		texture = chip.texture if chip else EMPTY_TEXTURE

@onready var label := $Label

@export var count := 0: ## How many of the chip there are.
	set(to):
		count = to
		if label: label.text = str(count)
		
		if count == 0: chip = null
	

const CHIP_NODE_SCENE := preload("res://Scenes/ChipNode.tscn")

func _ready() -> void:
	if label: label.text = str(count)

func _on_gui_input(event: InputEvent) -> void: if event is InputEventMouseButton and usable:
	if event.is_pressed() and not Global.held_chip and count > 0:
		## Create a new chip, and pick it up.
		var new:ChipNode = CHIP_NODE_SCENE.instantiate()
		
		new.chip = chip
		add_child(new)
		
		Global.held_chip = new
		
		count -= 1
		
		new.dropped.connect(_on_chip_dropped)

func _on_chip_dropped(): count += 1

## Custom Tooltippin'
func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip = preload("res://Scenes/Tooltip.tscn").instantiate()
	tooltip.text = for_text
	return tooltip
	
