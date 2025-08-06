extends Button

var index: int

@onready var itemName: Button = $"."
@onready var itemSprite: Sprite2D = $Sprite2D
@onready var descLabel: Label = $desc
@onready var hoverPlayer: AnimationPlayer = $hoverPlayer
@onready var activatePlayer: AnimationPlayer = $activatePlayer
@onready var activateTipLabel: Label = $activateTipLabel


var is_focused: bool = false

func _ready() -> void:
	hoverPlayer.play("hover")
	hide()


func _process(delta: float) -> void:
	if is_focused:
		descLabel.show()
	else:
		descLabel.hide()


func activate():
	activatePlayer.play("activateEffect")


func _on_stim_button_pressed() -> void:
	activatePlayer.play("activateIdle")


func _on_mouse_entered() -> void:
	is_focused = true


func _on_mouse_exited() -> void:
	is_focused = false
