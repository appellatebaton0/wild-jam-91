@tool
class_name TransitionOverlay extends Control
## Manages the slide transition rects.

@export var ease_min:float
@export var ease_max:float

@export var progress := 0.0

@export var texture:Texture2D
@export var rect_count := 30
@export var y_cover := 700 # How much space it needs to cover.

@export var x_size := 1500.0

var rects:Array[TextureRect]
var eases:Array[float]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for child in get_children(): if child is TextureRect:
		rects.append(child)
	
	var j := 0 
	while len(rects) < rect_count:
		var new = TextureRect.new()
		
		add_child(new)
		new.owner = owner
		
		rects.append(new)
		j+=1
		if j > 1000: 
			push_warning("Broke.")
			break
	
	for i in range(len(rects)):
		var rect := rects[i]
		rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		rect.texture = texture
		rect.position.y = (float(y_cover) / float(rect_count) * i) - 150
		rect.size = Vector2(1152 * 1.5, float(y_cover) / float(rect_count))
		eases.append(randf_range(ease_min, ease_max))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	for i in range(len(rects)):
		var rect := rects[i]
		rect.texture = texture
		rect.position.y = (float(y_cover) / float(rect_count) * i) - 150
		rect.size = Vector2(x_size, float(y_cover) / float(rect_count))
	
	while len(eases) < len(rects):
		eases.append(randf_range(ease_min, ease_max))
	
	for i in range(len(rects)):
		rects[i].position.x = -(x_size / 2) + (1152.0/2.0) + lerp(-x_size * 0.9, x_size * 0.9, ease(progress, eases[i]))
	pass
