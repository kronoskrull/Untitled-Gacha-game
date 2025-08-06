extends Control



func _ready() -> void:
	$AnimationPlayer.play("hover")



func _on_button_pressed() -> void:
	$AnimationPlayer.play("break")
	$"../Sprite2D".show()
	$"../desc".show()
	$"../Timer".start()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "break":
		
		queue_free()
