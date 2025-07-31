extends Control



@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var timer: Timer = $Timer



var common: Color = Color.GREEN_YELLOW
var rare: Color = Color.SKY_BLUE
var ultraRare: Color = Color.DARK_MAGENTA

func upgrade(index: int, rarity: String):
	label.text = "Spinner Slot " + str(index) + " Upgraded: " + str(rarity) + "!"
	match rarity:
		"rare":
			label.self_modulate = rare
		"ultraRare":
			label.self_modulate = ultraRare
	animation_player.play("upgrade")
	timer.start()
	show()


func _on_timer_timeout() -> void:
	hide()
