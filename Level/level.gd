extends Node2D

@onready var player: Node2D = $player
var playerDIR: Vector2 = Vector2(0, -32)
@onready var curDIRLabel: Label = $Control/debugPanel/VBoxContainer/curDIRlabel/curDIR

var obtainablePause: bool = true
@onready var fadeRect: ColorRect = $fadeRect

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
		
		var distance: int
		match spinResult:
			0:
				distance = 0
				move(distance)
				effect.text = "Move forward 0 spaces"
			1:
				distance = 1
				move(distance)
				effect.text = "Move forward 1 space"
			2:
				distance = 2
				move(distance)
				effect.text = "Move forward 2 spaces"
			3:
				distance = 3
				move(distance)
				effect.text = "Move forward 3 spaces"
			4:
				distance = 4
				move(distance)
				effect.text = "Move forward 4 spaces"
			5:
				distance = 5
				move(distance)
				effect.text = "Move forward 5 spaces"
			6:
				money += 2
				monUpdate()
				effect.text = "Gain 2 coins"
				canSpin = true
			7:
				money += 3
				monUpdate()
				effect.text = "Gain 3 coins"
				canSpin = true
			8:
				money += 5
				monUpdate()
				effect.text = "Gain 5 coins"
				canSpin = true
			9:
				money -= 1
				monUpdate()
				effect.text = "Lose 1 coin ;)"
				canSpin = true



func move(distance: int) -> void:
	if distance > 0:
		for i in distance:
			i = distance
			if i > 0:
				player.position = Vector2(player.position.x + playerDIR.x, player.position.y + playerDIR.y)
				await pauseForObtainable()
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
