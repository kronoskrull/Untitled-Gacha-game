extends Panel



func _process(delta: float) -> void:
	if Input.is_action_pressed("spinnerMenu"):
		show()
	else:
		hide()
