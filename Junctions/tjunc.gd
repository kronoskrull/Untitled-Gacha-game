extends Node2D


# T-junc code assumes that the t is right side up  (pointing down). For any other iteration the type 
# must be specified

@export var dirType: int = 0



func _on_area_2d_area_entered(area: Area2D) -> void:
	#breakpoint
	var reroll = false
	var playerDIR = area.get_parent().get_parent().get_parent().playerDIR
	area.get_parent().get_parent().get_parent().playerDIR = rollDIR(playerDIR, reroll)
	



func rollDIR(playerDIR, reroll: bool) -> Vector2:
	randomize()
	var i = randi_range(0, 2)
	
	match dirType:
		
		0: # Standing T shape
			
			match i:
				0: # Left from point
					if playerDIR != Vector2(32, 0):
							playerDIR = Vector2(-32, 0)
							return playerDIR
					elif !reroll:
						reroll = true
						rollDIR(playerDIR, reroll)
					elif reroll:
						var r = randi_range(0, 1)
						if r > 0:
							playerDIR = Vector2(-32, 0)
						else:
							playerDIR = Vector2(0, 32)
							
				1: # Down from point
					if playerDIR != Vector2(0, -32):
						playerDIR = Vector2(0, 32)
						return playerDIR
					elif !reroll:
						reroll = true
						rollDIR(playerDIR, reroll)
					elif reroll:
						var r = randi_range(0, 1)
						if r > 0:
							playerDIR = Vector2(0, 32)
						else:
							playerDIR = Vector2(0, -32)
				2: # Right from point
					if playerDIR != Vector2(-32, 0):
						playerDIR = Vector2(32, 0)
						return playerDIR
					elif !reroll:
						reroll = true
						rollDIR(playerDIR, reroll)
					elif reroll:
						var r = randi_range(0, 1)
						if r > 0:
							playerDIR = Vector2(32, 0)
						else:
							playerDIR = Vector2(0, 32)
		
		1: # Left-pointing T shape
			
			match i:
				0: # Left from point
					if playerDIR != Vector2(0, 32):
							playerDIR = Vector2(0, -32)
							return playerDIR
					elif !reroll:
						reroll = true
						rollDIR(playerDIR, reroll)
					elif reroll:
						var r = randi_range(0, 1)
						if r > 0:
							playerDIR = Vector2(0, -32)
						else:
							playerDIR = Vector2(-32, 0)
				1: # Down from point
					if playerDIR != Vector2(32, 0):
						playerDIR = Vector2(-32, 0)
						return playerDIR
					elif !reroll:
						reroll = true
						rollDIR(playerDIR, reroll)
					elif reroll:
						var r = randi_range(0, 1)
						if r > 0:
							playerDIR = Vector2(-32, 0)
						else:
							playerDIR = Vector2(0, -32)
				2: # Right from point
					if playerDIR != Vector2(0, -32):
						playerDIR = Vector2(0, 32)
						return playerDIR
					elif !reroll:
						reroll = true
						rollDIR(playerDIR, reroll)
					elif reroll:
						var r = randi_range(0, 1)
						if r > 0:
							playerDIR = Vector2(32, 0)
						else:
							playerDIR = Vector2(0, 32)
		
		2: # Right-pointing T shape
			
			match i:
				0: # Left from point
					if playerDIR != Vector2(0, -32):
							playerDIR = Vector2(0, 32)
							return playerDIR
					else:
						reroll = true
						rollDIR(playerDIR, reroll)
				1: # Down from point
					if playerDIR != Vector2(-32, 0):
						playerDIR = Vector2(32, 0)
						return playerDIR
					else:
						reroll = true
						rollDIR(playerDIR, reroll)
				2: # Right from point
					if playerDIR != Vector2(0, 32):
						playerDIR = Vector2(0, -32)
						return playerDIR
					else:
						reroll = true
						rollDIR(playerDIR, reroll)
		
		3: # Upside-Down T shape
			
			match i:
				0: # Left from point
					if playerDIR != Vector2(-32, 0):
							playerDIR = Vector2(32, 0)
							return playerDIR
					else:
						reroll = true
						rollDIR(playerDIR, reroll)
				1: # Down from point
					if playerDIR != Vector2(0, 32):
						playerDIR = Vector2(0, -32)
						return playerDIR
					else:
						reroll = true
						rollDIR(playerDIR, reroll)
				2: # Right from point
					if playerDIR != Vector2(32, 0):
						playerDIR = Vector2(-32, 0)
						return playerDIR
					else:
						reroll = true
						rollDIR(playerDIR, reroll)
	
	return playerDIR
