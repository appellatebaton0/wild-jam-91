class_name ChipSlot extends TextureRect
## Provides a control the player can interact with for a chip.

const EMPTY_TEXTURE:Texture2D = preload("res://Assets/Chips/EmptyChip.png")

@export var usable := true ## WHether this slot allows for its chip to be dragged out of it.

@export var chip:Chip: ## The chip this node is.
	set(to):
		
		chip = to
		
		texture = chip.texture if chip else EMPTY_TEXTURE

@onready var label := $Label
@onready var highlight := $Highlight

var mouse_over := false

func mouse_enter() -> void: mouse_over = true
func mouse_exit()  -> void: mouse_over = false

const HIGHLIGHT_TEXTURE := preload("res://Assets/Chips/ChipHighlight.png")

const CHIP_NODE_SCENE := preload("res://Scenes/ChipNode.tscn")

func _ready() -> void: 
	mouse_entered.connect(mouse_enter)
	mouse_exited.connect(mouse_exit)

func _process(_delta: float) -> void:
	if label: label.text = str(Global.chips[chip]) if Global.chips.has(chip) else ""
	highlight.texture = HIGHLIGHT_TEXTURE if usable and mouse_over and chip else null

var last_chip:Chip
func _on_gui_input(event: InputEvent) -> void: if event is InputEventMouseButton and usable:
	if event.is_pressed() and not Global.held_chip and chip:
		## Create a new chip, and pick it up.
		var new:ChipNode = CHIP_NODE_SCENE.instantiate()
		
		new.chip = chip
		add_child(new)
		
		Global.held_chip = new
		
		Global.chips[chip] -= 1
		last_chip = chip
		Global.chips_changed.emit(Global.chips)
		
		new.dropped.connect(_on_chip_dropped)

func _on_chip_dropped(): 
	
	if not chip: chip = last_chip
	
	print("dropped ", chip)
	
	if Global.chips.has(chip):
		print("has, adding")
		Global.chips[chip] += 1
	else:
		print("hasn't, creating.")
		Global.chips[chip] = 1
	
	Global.chips_changed.emit()

## Custom Tooltippin'
func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip = preload("res://Scenes/Tooltip.tscn").instantiate()
	tooltip.text = for_text
	return tooltip

func _get_tooltip(_at_position: Vector2) -> String:
	
	if not chip: return ""
	
	var response = tooltip_text
	
	response = response.replace("{color}", chip.color.to_html())
	response = response.replace("{name}", chip.name)
	response = response.replace("{description}", chip.info)
	
	return response
