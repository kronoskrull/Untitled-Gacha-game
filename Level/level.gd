extends Node3D

@onready var player: Node2D = $SubViewport/player
var playerDIR: Vector2 = Vector2(0, -32)
@onready var curDIRLabel: Label = $Control/debugPanel/VBoxContainer/curDIRlabel/curDIR

var obtainablePause: bool = false
@onready var fadeRect: ColorRect = $SubViewport/fadeRect

var canSpin: bool = true
var spinOptions: spinTables = spinTables.new()
var effectOps: Array = spinOptions.spinOpTable
var spinOps: Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
@export var money: int = 5
@onready var money_label: Label = $Control/Panel/moneyLabel

@onready var roll_result: Label = $Control/rollResult
@onready var effect: Label = $Control/effect


# Set the money count to whatever it's supposed to be
func _ready() -> void:
	monUpdate()

func _process(delta: float) -> void: 
	curDIRLabel.text = str(playerDIR)

func monUpdate() -> void:
	if money > 0:
		money_label.text = (" MONES:  " + str(money))
	else:
		money_label.text = (" BROKIE ALERT")

# This is the functio that will house the match table for all the different effects. When the function
# starts, it spins a random number 0 - 9 inclusive. This value is an index thatr corresponds to one of 
# the ten available positions on the player spinner.

# The main attraction for this function is the match table, which will house all the different possible
# effects. 0 - 9 correspond to the base movement of 0 or 5 spaces, base gain of 2, 3, or 5 coins, or
# loss of 1 extra coin that the spinner defaults to at the start of a run, and everything following 
# is some other effect in no particular order for now.

func interpretSpin() -> void:
	if money > 0 and canSpin:
		canSpin = false
		money -= 1
		monUpdate()
		var rawSpin = spinSpinner()
		var spinResult: int = spinOps[rawSpin]
		
		roll_result.text = str(spinResult)        #CULL
		
		var distance: int = spinResult

		move(distance)
		effect.text = "Move forward " + str(distance) + " spaces"



func move(distance: int) -> void:
	if distance > 0:
		for i in distance:
			i = distance
			if i > 0:
				await pauseForObtainable()
				player.position = Vector2(player.position.x + playerDIR.x, player.position.y + playerDIR.y)
				
				await get_tree().create_timer(0.6).timeout
				distance -= 1
		canSpin = true
	else:
		canSpin = true


func pauseForObtainable() -> void:
	
	while obtainablePause:
		fadeRect.color.a = lerpf(fadeRect.color.a, 0.5, 1)
		await get_tree().create_timer(5.0).timeout
		fadeRect.color.a = lerpf(fadeRect.color.a, 0, 1)
		obtainablePause = false
		continue
	

func getObtainable(obtainable: int) -> void:
	pauseForObtainable()
	match obtainable:
		0, 1, 2:
			print ("got common")
		3, 4, 5:
			print ("got rare!")
		6, 7, 8:
			print ("got ultra!!!!")



func spinSpinner() -> int:
	var spinResult: int
	
	spinResult = randi_range(0, 9)
	
	return spinResult


func _on_spin_button_pressed() -> void:
	interpretSpin()

func _on_resetbutton_pressed() -> void:
	get_tree().reload_current_scene()


func _on_add10_button_pressed() -> void:
	money += 10
	monUpdate()


func _on_posres_button_pressed() -> void:
	player.position = Vector2(576, 474)


func _on_dir_up_pressed() -> void:
	playerDIR = Vector2(0, -32)


func _on_dir_down_pressed() -> void:
	playerDIR = Vector2(0, 32)


func _on_dir_left_pressed() -> void:
	playerDIR = Vector2(-32, 0)


func _on_dir_right_pressed() -> void:
	playerDIR = Vector2(32, 0)
