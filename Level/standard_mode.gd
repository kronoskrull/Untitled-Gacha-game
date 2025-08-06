extends Button


func _on_mouse_entered() -> void:
	for child in get_children():
		if !child.is_in_group("exempt"):
			child.show()
	if $"../../../..".serPress >= 0 and $"../../../../lighting & env/lights/modeLights/SpotLight3D3".light_color == Color.RED:
		$"../../../../lighting & env/lights/modeLights/SpotLight3D3/AnimationPlayer".play_backwards("colorSwap")
		$"../../../../lighting & env/lights/modeLights/SpotLight3D4/AnimationPlayer2".play_backwards("colorSwap")


func _on_mouse_exited() -> void:
	for child in get_children():
		if !child.is_in_group("exempt"):
			child.hide()
