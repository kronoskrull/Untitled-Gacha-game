extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: RichTextLabel = $Label
@export var num: int
@onready var deathTimer: Timer = $deathTimer


func _ready() -> void:
	animation_player.play("dance")
	hide()

func _process(delta: float) -> void:
	if num >= 0:
		label.text = "[rainbow]+" + str(num) + " coins![/rainbow]"
	else:
		label.text = "[rainbow]" + str(num) + " coins![/rainbow]"

func _on_death_timer_timeout() -> void:
	hide()
