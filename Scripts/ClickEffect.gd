class_name ClickEffect extends GPUParticles2D
## Makes a little effect wherever the player clicks.

@export var emit_time := 0.05
var emit_timer := 0.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton: if event.pressed:
		emitting = true
		emit_timer = emit_time
		global_position = get_global_mouse_position()

func _process(delta: float) -> void:
	emit_timer = move_toward(emit_timer, 0.0, delta)
	if emit_timer <= 0: emitting = false
