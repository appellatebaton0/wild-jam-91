class_name ReplayButton extends Button

@export var anim_player:AnimationPlayer

func _pressed() -> void:
	Global.end_run()
	anim_player.play("Replay")
