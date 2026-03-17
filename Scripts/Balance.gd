class_name Balance extends Label
## Shows the player's current balance.

@export var digits := 5

var display_value := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.money = 81241
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	text = as_digits()
	
	display_value = move_toward(display_value, Global.money, as_tenth() / 20)
	pass

func as_digits() -> String:
	var a = str(display_value)
	
	for i in range(digits - a.length()):
		a = "0" + a
	
	return a

func as_tenth() -> int:
	return 1 * pow(10, str(abs(Global.money - display_value)).length())
