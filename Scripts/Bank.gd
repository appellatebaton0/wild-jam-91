class_name Bank extends Label
## Shows the player's current balance.

@export var digits := 5

var display_value := 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	text = "$" + as_digits()
	
	@warning_ignore("narrowing_conversion")
	display_value = move_toward(display_value, max(Global.bank,0), max(floori(as_tenth() / 20.0), 1))

func as_digits() -> String:
	var a = str(display_value)
	
	for i in range(digits - a.length()):
		a = "0" + a
	
	return a

func as_tenth() -> int:
	return 1 * floori(pow(10, str(abs(max(Global.bank,0) - display_value)).length()))
