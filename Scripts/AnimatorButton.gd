class_name AnimatorButton extends Button
## Plays an animation off an AnimationPlayer when pressed.

@onready var tut_overlay:TutorialFocus = get_tree().get_first_node_in_group("TutOverlay")
@export var pressed_sfx:AudioStream = preload("res://Assets/SFX/click_mallet.mp3")
var sfx_player:AudioStreamPlayer

func _ready() -> void:
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	sfx_player.bus = &"SFX"
	sfx_player.stream = pressed_sfx
	pressed.connect(sfx_player.play)

## If the tut current index is [key], move in [value] direction when pressed.
@export var tutorial_progressor:Dictionary[int, int]

@export var anim_name:StringName

@onready var animator := get_animator()
func get_animator(with:Node = self, depth := 10) -> AnimationPlayer:
	
	if depth == 0 or not with: return null
	
	if with is AnimationPlayer:
		return with
	
	for child in with.get_children(): if child is AnimationPlayer:
		return child
	
	return get_animator(with.get_parent(), depth - 1)

func _pressed() -> void: if animator: if tut_overlay.interpolation_timer == 1.0:
	if not animator.is_playing() and animator.has_animation(anim_name):
		animator.play(anim_name)
	
	if tut_overlay.visible:
		if tutorial_progressor.has(tut_overlay.next_index):
			var dir = tutorial_progressor[tut_overlay.next_index]
			match dir:
				-1: tut_overlay.last()
				1: tut_overlay.next()
		
		elif tutorial_progressor.has(-1):
			tut_overlay.set_index(tutorial_progressor[-1])

## Custom Tooltippin'
func _make_custom_tooltip(for_text: String) -> Object:
	if for_text == "": return null
	
	var tooltip = preload("res://Scenes/Tooltip.tscn").instantiate()
	tooltip.text = for_text
	return tooltip
