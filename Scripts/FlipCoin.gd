class_name FlipCoin extends TextureRect

@export var wait_range := Vector2(1.0, 1.5)
@export var flip_range := Vector2(1.0, 2.0)

@export var flip_easing := -3.5

var flipping = false

var time  := 0.0
var timer := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void: time = randf_range(wait_range.x, wait_range.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	timer = move_toward(timer, time, delta)
	
	if timer >= time:
		
		flipping = not flipping
		
		if flipping:
			time = randf_range(flip_range.x, flip_range.y)
		else:
			time = randf_range(wait_range.x, wait_range.y)
		
		timer = 0.0
	
	scale.x = get_x()

func get_x() -> float:
	if not flipping: return 1.0
	
	return abs( 2 * (ease(timer / time, flip_easing) - 0.5) )
	
