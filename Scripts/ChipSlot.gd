class_name ChipSlot extends TextureRect
## Provides a control the player can interact with for a chip.

@export var chip:Chip: ## The chip this node is.
	set(to):
		if to == chip: return
		
		chip = to
		
		texture = chip.texture

@export var count := 0 ## How many of the chip there are.

const CHIP_NODE_SCENE := preload("res://Scenes/ChipNode.tscn")

func _on_gui_input(event: InputEvent) -> void: if event is InputEventMouseButton:
	if event.is_pressed() and not Global.held_chip and count > 0:
		## Create a new chip, and pick it up.
		var new:ChipNode = CHIP_NODE_SCENE.instantiate()
		
		add_child(new)
		
		new.chip = chip
		
		count -= 1
		
		Global.held_chip = new
		print("!")
	
	
	print(event)
	pass # Replace with function body.
