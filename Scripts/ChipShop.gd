class_name ChipShop extends GridContainer
## Manages all the ShopEntries within it.

const CHIP_PATH := "res://Assets/ChipResources/"

@onready var chip_bag := get_chips() ## The chips available to sell.
@onready var slots    := get_slots() ## The ShopEntries in this container.

## Reload the contents of the shop.
func reload_shop() -> void:
	
	var bag := chip_bag.duplicate()
	
	for slot in slots:
		
		if len(bag) == 0: 
			slot.chip = null
			continue
		
		# Pop a random chip from the bag, and stuff it in the slot.
		slot.chip = bag.pop_at(randi_range(0, len(bag) - 1))

## Get various lists.
func get_slots() -> Array[ShopEntry]:
	var response:Array[ShopEntry]
	for child in get_children(): if child is ShopEntry:
		response.append(child)
	return response
func get_chips() -> Array[Chip]:
	
	var chips:Array[Chip]
	
	var dir = DirAccess.open(CHIP_PATH)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir(): if file_name.contains(".tres"):
				
				file_name = file_name.replace(".remap", "") # Don't even think about it.
				
				# Load the file, and remember it if it's a chip.
				var file := load(CHIP_PATH + file_name)
				
				if file is Chip: chips.append(file)
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	return chips
