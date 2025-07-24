extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	var player = area.get_parent().get_parent()
	
	player.playerDIR = rollDIR(player.playerDIR)
	


func rollDIR(playerDIR) -> Vector2:
	var i = randi_range(0, 3)
	
	match i:
		0: # South
			if playerDIR != Vector2(0, -16):
				playerDIR = Vector2(0, 16)
				return playerDIR
			else:
				rollDIR(playerDIR)
	
		1: # West
			if playerDIR != Vector2(16, 0):
				playerDIR = Vector2(-16, 0)
				return playerDIR
			else:
				rollDIR(playerDIR)
		
		2: # East
			if playerDIR != Vector2(-16, 0):
				playerDIR = Vector2(16, 0)
				return playerDIR
			else:
				rollDIR(playerDIR)
		
		3: # North
			if playerDIR != Vector2(0, 16):
				playerDIR = Vector2(0, -16)
				return playerDIR
			else:
				rollDIR(playerDIR)
	
	
	
	
	
	
	
	return playerDIR
