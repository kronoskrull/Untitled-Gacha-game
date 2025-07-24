extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	var player = area.get_parent().get_parent()
	if player.playerDIR == Vector2(16, 0):
		player.playerDIR = Vector2(0, 16)
	else:
		player.playerDIR = Vector2(-16, 0)
