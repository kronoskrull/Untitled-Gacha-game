extends PanelContainer

@onready var level: Node3D = $"../.."


func triggerEffect(effect: Vector2) -> void:
	level.eventPause = true
	level.debugSelect = true
	level.debugRarity = effect.x
	level.debugX = effect.y
	level.spaceEvent()


func _on_button_pressed() -> void:
	triggerEffect(Vector2(0, 0))


func _on_button_2_pressed() -> void:
	triggerEffect(Vector2(0, 1))


func _on_button_3_pressed() -> void:
	triggerEffect(Vector2(0, 2))


func _on_button_4_pressed() -> void:
	triggerEffect(Vector2(0, 3))


func _on_button_5_pressed() -> void:
	triggerEffect(Vector2(0, 4))


func _on_button_6_pressed() -> void:
	triggerEffect(Vector2(0, 5))


func _on_button_7_pressed() -> void:
	triggerEffect(Vector2(1, 0))


func _on_button_8_pressed() -> void:
	triggerEffect(Vector2(1, 1))


func _on_button_9_pressed() -> void:
	triggerEffect(Vector2(1, 2))


func _on_button_10_pressed() -> void:
	triggerEffect(Vector2(1, 3))


func _on_button_11_pressed() -> void:
	triggerEffect(Vector2(1, 4))


func _on_button_12_pressed() -> void:
	triggerEffect(Vector2(1, 5))


func _on_button_13_pressed() -> void:
	triggerEffect(Vector2(2, 0))


func _on_button_14_pressed() -> void:
	triggerEffect(Vector2(2, 1))


func _on_button_15_pressed() -> void:
	triggerEffect(Vector2(2, 2))


func _on_button_16_pressed() -> void:
	triggerEffect(Vector2(2, 3))


func _on_button_17_pressed() -> void:
	triggerEffect(Vector2(2, 4))


func _on_button_18_pressed() -> void:
	triggerEffect(Vector2(2, 5))
