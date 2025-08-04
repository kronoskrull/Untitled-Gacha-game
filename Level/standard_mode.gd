extends Button

func _on_focus_entered() -> void:
	for child in get_children():
		if !child.is_in_group("exempt"):
			child.show()


func _on_focus_exited() -> void:
	for child in get_children():
		if !child.is_in_group("exempt"):
			child.hide()
