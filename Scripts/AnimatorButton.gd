class_name AnimatorButton extends Button
## Plays an animation off an AnimationPlayer when pressed.

@export var anim_name:StringName

@onready var animator := get_animator()
func get_animator(with:Node = self, depth := 10) -> AnimationPlayer:
	
	if depth == 0 or not with: return null
	
	if with is AnimationPlayer:
		return with
	
	for child in with.get_children(): if child is AnimationPlayer:
		return child
	
	return get_animator(with.get_parent(), depth - 1)

func _pressed() -> void: if animator:
	if not animator.is_playing() and animator.has_animation(anim_name):
		animator.play(anim_name)
