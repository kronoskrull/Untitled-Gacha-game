extends Node3D

@onready var player: Node2D = $SubViewport/player
var playerDIR: Vector2 = Vector2(0, 32)
@onready var curDIRLabel: Label = $Control/debugPanel/VBoxContainer/curDIRlabel/curDIR

var obtainablePause: bool = false
@onready var fadeRect: ColorRect = $SubViewport/fadeRect

var canSpin: bool = true
var spinOptions: spinTables = spinTables.new()
var effectOps: Array = spinOptions.spinOpTable

var spinOps: Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

var obtainedItems: Array = []

@export var money: int = 5
@onready var money_label: Label = $Control/Panel/moneyLabel

@onready var roll_result: Label = $Control/rollResult
@onready var effect: Label = $Control/effect


var lastObtained: int
@onready var itemSprite: Sprite2D = $SubViewport/obtainedAnim/itemSprite
@onready var itemAnims: AnimationPlayer = $SubViewport/obtainedAnim/AnimationPlayer
@onready var itemName: Label = $SubViewport/obtainedAnim/itemname
@onready var itemEffect: Label = $SubViewport/obtainedAnim/itemEffect
@onready var commentLabel: Label = $SubViewport/obtainedAnim/commentLabel
@onready var obtainedAnim: Node2D = $SubViewport/obtainedAnim
var itemsActivating: Array = [0]
var newItemIndex: int
var newActLabel: String
@onready var invItem = preload("res://invItem.tscn")
@onready var inventory: VBoxContainer = $inv/inventoryPanel/VBoxContainer
var invItemInstance
var rarity: Color

var common: Color = Color.GREEN_YELLOW
var rare: Color = Color.SKY_BLUE
var ultraRare: Color = Color.DARK_MAGENTA


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


func interpretSpin() -> void:
	if money > 0 and canSpin:
		canSpin = false
		money -= 1
		monUpdate()
		var rawSpin = spinSpinner()
		var spinResult: int = spinOps[rawSpin]
		
		if obtainedItems.has(5) and spinResult == 0:           #TODO
			var i = randi_range(0, 3)
			if i < 1:
				itemsActivating.clear()
				itemsActivating.append(5)
				itemActivate(itemsActivating)
				interpretSpin()
		
		
		roll_result.text = str(spinResult)                     #CULL
		
		
		var distance: int = spinResult
		
		
		if obtainedItems.has(1):
			var i = randi_range(0, 9)
			if i < 1:
				itemsActivating.clear()
				itemsActivating.append(1)
				itemActivate(itemsActivating)
				distance += 1
		if obtainedItems.has(3):
			itemsActivating.clear()
			itemsActivating.append(3)
			itemActivate(itemsActivating)
			distance += 1
		
		if obtainedItems.has(6):
			itemsActivating.clear()
			itemsActivating.append(6)
			itemActivate(itemsActivating)
			distance += 2

		move(distance)
		effect.text = "Move forward " + str(distance) + " spaces"


func itemActivate(items: Array) -> void:
	for c in inventory.get_children():
		if items.has(c.index):
			c.activate()
		await get_tree().create_timer(0.1).timeout

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
		invItemInstance = invItem.instantiate()
		obtainableAnim()
		
		await get_tree().create_timer(5.0).timeout
		fadeRect.color.a = lerpf(fadeRect.color.a, 0, 1)
		obtainedAnim.hide()
		itemAnims.stop()
		
		
		inventory.add_child(invItemInstance)
		invItemInstance.z_index = 5
		invItemInstance.index = newItemIndex
		invItemInstance.itemName.text = itemName.text
		invItemInstance.itemName.self_modulate = Color(rarity)
		invItemInstance.itemSprite.texture = itemSprite.texture
		invItemInstance.descLabel.text = itemEffect.text
		invItemInstance.activateTipLabel.text = newActLabel
		invItemInstance.show()
		
		obtainablePause = false
		continue
	

func obtainableAnim():
	
	match lastObtained:
		0:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt001.png"))
			itemName.text = "Leg Day"
			itemEffect.text = "1 in 10 chance to move an extra space"
			commentLabel.text = "Maybe hitting the gym isn't such a bad idea"
			newActLabel = "+1 to roll!"
			rarity = common
			
		1:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt002.png"))
			itemName.text = "Lucky Break"
			itemEffect.text = "1 in 5 chance for +1 coins when you obtain coins"
			commentLabel.text = "A one-leaf clover HAS to be lucky sometime, right?"
			newActLabel = "+1 coin!"
			rarity = common
		2:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt001.png"))
			itemName.text = "Negative Negation"
			itemEffect.text = "1 in 20 chance to negate a negative space effect"
			commentLabel.text = "If I can't see it, it doesn't exist!"
			newActLabel = "Effect Negated!"
			rarity = common
		3:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt001.png"))
			itemName.text = "Leg Day+"
			itemEffect.text = "Adds +1 to every spin"
			commentLabel.text = "Those gains are really paying off, huh?"
			newActLabel = "+1 to roll!"
			rarity = rare
		4:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt001.png"))
			itemName.text = "Bank Error"
			itemEffect.text = "When gaining/losing coins, 1 in 4 chance to double the amount"
			commentLabel.text = "Bank error in your favor (or not)"
			newActLabel = "ERR0R"
			rarity = rare
		5:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt001.png"))
			itemName.text = "Anywhere But Here"
			itemEffect.text = "1 in 4 chance to reroll every 0"
			commentLabel.text = "We've all cheated at least once, right?"
			newActLabel = "Reroll!"
			rarity = rare
		6:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt001.png"))
			itemName.text = "Leg Day++"
			itemEffect.text = "Adds +2 to every spin"
			commentLabel.text = "What are they putting in your pre-workout, dude?!"
			newActLabel = "+2 to roll!"
			rarity = ultraRare
		7:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt001.png"))
			itemName.text = "Two's Company"
			itemEffect.text = "Doubles all effect, item and roll odds"
			commentLabel.text = "Oops, All Sixes!"
			rarity = ultraRare
		8:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt001.png"))
			itemName.text = "Scot-Free"
			itemEffect.text = "Pay 10 coins to negate a negative space effect"
			commentLabel.text = "Just like in real life!"
			newActLabel = "Consequences Escaped!"
			rarity = ultraRare
		9:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt001.png"))
			itemName.text = "Multiroll"
			itemEffect.text = "Roll 3 times, last roll upgrades the space effect!"
			commentLabel.text = "This is where the fun begins!"
			newActLabel = "Multiroll!"
			
	
	
	obtainedAnim.show()
	itemAnims.play("blink_bob")


func getObtainable(obtainable: int) -> void:
	newItemIndex = obtainable
	obtainedItems.append(obtainable)
	match obtainable:
		0, 1, 2:
			print (spinOptions.masterObtainablesList[obtainable])
			lastObtained = obtainable
		3, 4, 5:
			print (spinOptions.masterObtainablesList[obtainable])
			lastObtained = obtainable
		6, 7, 8:
			print (spinOptions.masterObtainablesList[obtainable])
			lastObtained = obtainable
	pauseForObtainable()



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
	player.position = Vector2(954, 804)


func _on_dir_up_pressed() -> void:
	playerDIR = Vector2(0, -32)


func _on_dir_down_pressed() -> void:
	playerDIR = Vector2(0, 32)


func _on_dir_left_pressed() -> void:
	playerDIR = Vector2(-32, 0)


func _on_dir_right_pressed() -> void:
	playerDIR = Vector2(32, 0)
