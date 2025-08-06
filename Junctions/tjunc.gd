extends Node2D


# T-junc code assumes that the t is right side up  (pointing down). For any other iteration the type 
# must be specified

@export var dirType: int = 0
var rerollFail: int
var dirRoll: Vector2
var rolling: bool

var newDIR: Vector2
var nextDIR: Vector2

func _on_area_2d_area_entered(area: Area2D) -> void:
	#breakpoint
	var reroll = false
	var player = area.get_parent().get_parent().get_parent()
	var i = randi_range(0, 2)
	if !rolling:
		rolling = true
		dirRoll = rollDIR(i, player.playerDIR, reroll, rerollFail)
	rolling = false
	player.playerDIR = dirRoll



func rollDIR(randI: int, playerDIR, reroll: bool, rerollInt: int) -> Vector2:
	randomize()
	if reroll:
		match randI:
			0:
				randI = [1, 2].pick_random()
			1:
				randI = [0, 2].pick_random()
			2:
				randI = [0, 1].pick_random()
	
	var i = randI
	
	
	match dirType:
		
		0: # Standing T shape
			
			match i:
				0: # Left from point
					if playerDIR != Vector2(32, 0):
							newDIR = Vector2(-32, 0)
					elif !reroll:
						reroll = true
						rerollFail = 0
						rollDIR(randI, playerDIR, reroll, rerollFail)
							
				1: # Down from point
					if playerDIR != Vector2(0, -32):
						newDIR = Vector2(0, 32)
					elif !reroll:
						reroll = true
						rerollFail = 1
						rollDIR(randI, playerDIR, reroll, rerollFail)
				2: # Right from point
					if playerDIR != Vector2(-32, 0):
						newDIR = Vector2(32, 0)
					elif !reroll:
						reroll = true
						rerollFail = 2
						rollDIR(randI, playerDIR, reroll, rerollFail)
		
		1: # Left-pointing T shape
			
			match i:
				0: # Left from point
					if playerDIR != Vector2(0, 32):
							newDIR = Vector2(0, -32)
					elif !reroll:
						reroll = true
						rerollFail = 0
						rollDIR(randI, playerDIR, reroll, rerollFail)
				1: # Down from point
					if playerDIR != Vector2(32, 0):
						newDIR = Vector2(-32, 0)
					elif !reroll:
						reroll = true
						rerollFail = 1
						rollDIR(randI, playerDIR, reroll, rerollFail)
				2: # Right from point
					if playerDIR != Vector2(0, -32):
						newDIR = Vector2(0, 32)
					elif !reroll:
						reroll = true
						rerollFail = 2
						rollDIR(randI, playerDIR, reroll, rerollFail)
		
		2: # Right-pointing T shape
			
			match i:
				0: # Left from point
					if playerDIR != Vector2(0, -32):
						newDIR = Vector2(0, 32)
					else:
						reroll = true
						rerollFail = 0
						rollDIR(randI, playerDIR, reroll, rerollFail)
				1: # Down from point
					if playerDIR != Vector2(-32, 0):
						newDIR = Vector2(32, 0)
					else:
						reroll = true
						rerollFail = 1
						rollDIR(randI, playerDIR, reroll, rerollFail)
				2: # Right from point
					if playerDIR != Vector2(0, 32):
						newDIR = Vector2(0, -32)
					else:
						reroll = true
						rerollFail = 2
						rollDIR(randI, playerDIR, reroll, rerollFail)
		
		3: # Upside-Down T shape
			
			match i:
				0: # Left from point
					if playerDIR != Vector2(-32, 0):
						newDIR = Vector2(32, 0)
					else:
						reroll = true
						rerollFail = 0
						rollDIR(randI, playerDIR, reroll, rerollFail)
				1: # Down from point
					if playerDIR != Vector2(0, 32):
						newDIR = Vector2(0, -32)
					else:
						reroll = true
						rerollFail = 1
						rollDIR(randI, playerDIR, reroll, rerollFail)
				2: # Right from point
					if playerDIR != Vector2(32, 0):
						newDIR = Vector2(-32, 0)
					else:
						reroll = true
						rerollFail = 2
						rollDIR(randI, playerDIR, reroll, rerollFail)
	nextDIR = newDIR
	return nextDIR
