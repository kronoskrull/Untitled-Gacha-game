extends PanelContainer

@onready var level: Node3D = $"../.."

var item: Array
@export var obtDatabase: Script

func obtainItem(item: Array) -> void:
	level.obtainablePause = true
	level.getObtainable(item)


func _on_button_pressed() -> void:
	item = obtDatabase.COMMON[0]
	obtainItem(item)

#func _on_button_2_pressed() -> void:
	#item = 1
	#obtainItem(item)
#
#
#func _on_button_3_pressed() -> void:
	#item = 2
	#obtainItem(item)
#
#
#func _on_button_4_pressed() -> void:
	#item = 3
	#obtainItem(item)
#
#
#func _on_button_5_pressed() -> void:
	#item = 4
	#obtainItem(item)
#
#
#func _on_button_6_pressed() -> void:
	#item = 5
	#obtainItem(item)
#
#
#func _on_button_7_pressed() -> void:
	#item = 6
	#obtainItem(item)
#
#
#func _on_button_8_pressed() -> void:
	#item = 7
	#obtainItem(item)
#
#
#func _on_button_9_pressed() -> void:
	#item = 8
	#obtainItem(item)
