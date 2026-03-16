@tool
class_name TutorialFocus extends Control

## Emitted when the current key changes - note that NEXT is the actual current key that this reflects.
signal key_changed(to:int)
signal last_key ## Emitted when moved to the last key in the list.

@export var tooltip:RichTextLabel
@export var keys:Array[Dictionary]

@export_tool_button("Save Key") var save_button := save_key
@export_tool_button("Clear Keys") var clear_button := clear_keys
@export_tool_button("Reset Timer") var reset_button := reset_timer
@export var save_index := -1

@export var interpolating := true
@export var interpolation_time := 1.0
var interpolation_timer := 0.0
@export var easing := -2

@export var current_index := 0
@export var next_index := 0

## Lock moving forwards by the normal inputs - has to be a signal.
@export var front_locks:Array[int]

func save_key():
	var unre := EditorInterface.get_editor_undo_redo()
	unre.create_action("Add Transform Key")
	
	var new_keys = keys.duplicate()
	
	if save_index >= 0:
		new_keys.insert(save_index, new_key())
	else:
		new_keys.append(new_key())
	
	unre.add_do_property(self, "keys", new_keys)
	unre.add_undo_property(self, "keys", keys)
	
	unre.commit_action()
	
func clear_keys(): keys.clear()
func reset_timer(): interpolation_timer = 0

func _ready() -> void: if not Engine.is_editor_hint(): 
	interpolating = true
	current_index = 0
	next_index = 0

func _process(delta: float) -> void:
	if interpolating and len(keys):
		
		apply(key_lerp(keys[current_index], keys[next_index], ease(interpolation_timer, easing)))
		
		if tooltip:
			tooltip.visible_characters = lerp(0, tooltip.get_total_character_count(), interpolation_timer)
		
		interpolation_timer = move_toward(interpolation_timer, 1.0, delta / interpolation_time)
		
		if not Engine.is_editor_hint():
			if Input.is_action_just_pressed("TutorialNext") and not dir_is_locked(1): next()
			if Input.is_action_just_pressed("TutorialLast") and not dir_is_locked(-1): last()

func next():set_index(wrap(next_index + 1, 0, len(keys)))
func last(): set_index(wrap(next_index - 1, 0, len(keys)))
func set_index(to:int): if interpolation_timer == 1.0:
	current_index = next_index
	next_index = to
	
	interpolation_timer = 0.0
	key_changed.emit(next_index)
	if next_index == len(keys) - 1:
		last_key.emit()

func new_key() -> Dictionary[String, Variant]:
	return {
		"position": position,
		"size": size,
		"tip_position": tooltip.position,
		"tip_size": tooltip.size,
		"tip_text": tooltip.text
	}

func key_lerp(a, b, t) -> Dictionary:
	var c:Dictionary
	
	for key in ["position", "size", "tip_position", "tip_size"]:
		c[key] = lerp(a[key], b[key], t)
	c["tip_text"] = b["tip_text"]
	
	return c

func apply(key:Dictionary):
	position = key["position"]
	size = key["size"]
	if tooltip:
		tooltip.position = key["tip_position"]
		tooltip.size = key["tip_size"]
		tooltip.text = key["tip_text"]

func dir_is_locked(dir:int) -> bool:
	
	var dir_value = wrap(current_index + dir, 0, len(keys))
	
	return front_locks.has(dir_value)
