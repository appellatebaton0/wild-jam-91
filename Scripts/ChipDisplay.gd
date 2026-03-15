class_name ChipDisplay extends HBoxContainer
## Displays the current state of Global.chip

@export var usable := true

func _ready() -> void:
	Global.chips_changed.connect(_on_chips_changed)
	_on_chips_changed(Global.chips)

const SLOT_SCENE := preload("res://Scenes/ChipSlot.tscn")

## Update the contents of this display.
func _on_chips_changed(to:Dictionary[Chip, int]):
	
	while get_child_count() < len(to):
		var new:ChipSlot = SLOT_SCENE.instantiate()
		new.usable = usable
		add_child(new)
	
	var slots:Array[ChipSlot]
	for child in get_children(): if child is ChipSlot: slots.append(child)
	
	var keys = to.keys()
	var vals = to.values()
	
	for i in range(len(slots)):
		if len(keys) > i:
			slots[i].chip  = keys[i]
			slots[i].count = vals[i]
		else:
			slots[i].count = 0
