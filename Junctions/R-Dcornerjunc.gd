extends Node2D




func _on_area_2d_area_entered(area: Area2D) -> void:
	var player = area.get_parent().get_parent().get_parent()
	if player.playerDIR == Vector2(-32, 0):
		player.playerDIR = Vector2(0, 32)
	else:
		player.playerDIR = Vector2(32, 0)
