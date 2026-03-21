class_name MusicHandler extends AudioStreamPlayer

@export var current_track = -1
@export var transition_speed := 40.0

func _process(delta: float) -> void:
	if stream is AudioStreamSynchronized:
		for i in range(stream.get_stream_count()):
			var vol = stream.get_sync_stream_volume(i)
			if i == current_track:
				stream.set_sync_stream_volume(i, move_toward(vol, 0.0, delta * transition_speed))
			else:
				stream.set_sync_stream_volume(i, move_toward(vol, -60.0, delta * transition_speed))
