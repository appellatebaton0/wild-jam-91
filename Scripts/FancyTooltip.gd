class_name FancyTooltip extends Control
## Literally just adds support for the fancy tooltip.

var special_properties:Dictionary[StringName, String]

## Custom Tooltippin'
func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip = preload("res://Scenes/Tooltip.tscn").instantiate()
	tooltip.text = for_text
	return tooltip

func _get_tooltip(_at_position: Vector2) -> String:
	var response = tooltip_text
	
	for key in special_properties:
		response = response.replace(key, special_properties[key])
	
	return response
