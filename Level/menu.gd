extends Control


@onready var main_options: PanelContainer = $mainOptions
@onready var sub_options: PanelContainer = $subOptions
@onready var subAnims: AnimationPlayer = $subOptions/AnimationPlayer

var menuOpen = true
var subOpen = false

func _on_newgame_pressed() -> void:
	if !subOpen:
		$mainOptions/VBoxContainer/newgame/buttonSprite/AnimationPlayer.play("pressed")
		$AudioStreamPlayer2D.play()
		$subOptions/AnimationPlayer.play("appear")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		if menuOpen:
			if subOpen:
				$"..".serPress = 0
				$"..".standPressed = 0
				subAnims.play_backwards("disappear")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"appear":
			subOpen = true
		"disappear":
			subOpen = false
