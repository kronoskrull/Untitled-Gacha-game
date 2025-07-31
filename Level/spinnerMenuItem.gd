extends Button

@export var index: int

@onready var itemName: Button = $"."
@onready var descLabel: Label = $desc
@onready var slot_upgrade_notif: Control = $"../../../slotUpgradeNotif"

var rarity: Color

var common: Color = Color.GREEN_YELLOW
var rare: Color = Color.SKY_BLUE
var ultraRare: Color = Color.DARK_MAGENTA

var timesRolled: int

var is_focused: bool = false
var notyetRare: bool = true
var notyetUltraRare: bool = true

func _process(delta: float) -> void:
	if is_focused:
		descLabel.show()
	else:
		descLabel.hide()
	
	if timesRolled < 1:
		descLabel.text = "Common: Move " + str(index) + " spaces."
		descLabel.self_modulate = common
		itemName.self_modulate = common
	
	if timesRolled >= 1:
		if notyetRare:
			slot_upgrade_notif.upgrade(index, "rare")
			notyetRare = false
		descLabel.text = "Rare: Move " + str(index + 1) + " spaces!"
		descLabel.self_modulate = rare
		itemName.self_modulate = rare
	
	if timesRolled >= 2:
		if notyetUltraRare:
			slot_upgrade_notif.upgrade(index, "ultraRare")
			notyetUltraRare = false
		descLabel.text = "Ultra Rare: Move " + str(index + 2) + " spaces!!"
		descLabel.self_modulate = ultraRare
		itemName.self_modulate = ultraRare


func _on_button_down() -> void:
	is_focused = true


func _on_button_up() -> void:
	is_focused = false
