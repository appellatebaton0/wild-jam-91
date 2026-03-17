class_name ChipShop extends GridContainer
## Manages all the ShopEntries within it.

const CHIP_PATH := "res://Assets/Chips"

@onready var chip_bag := get_chips()

func get_chips() -> Array[Chip]:
	
	var
