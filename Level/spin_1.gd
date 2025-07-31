extends AudioStreamPlayer3D


func _process(delta: float) -> void:
	if $"..".spinning:
		volume_db -= 7 * delta
	else:
		stop()
		volume_db = 3
