extends Node3D

@onready var player: Node2D = $SubViewport/player
var playerDIR: Vector2 = Vector2(0, 32)
@onready var curDIRLabel: Label = $Control/debugPanel/VBoxContainer/curDIRlabel/curDIR

var obtainablePause: bool = false
@onready var fadeRect: ColorRect = $SubViewport/fadeRect

var canSpin: bool = true
@onready var spinner: CSGCylinder3D = $"lighting & env/spinnerPLACEHOLDER"

var spinOptions: spinTables = spinTables.new()
var effectOps: Array = spinOptions.spinOpTable

var spinOps: Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

var obtainedItems: Array = []

@export var money: int = 5
@onready var money_label: Label = $Control/Panel/moneyLabel

@onready var roll_result: Label = $Control/rollResult


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

var positive: Color = Color.LAWN_GREEN
var negative: Color = Color.DARK_RED

var common: Color = Color.GREEN_YELLOW
var rare: Color = Color.SKY_BLUE
var ultraRare: Color = Color.DARK_MAGENTA

var eventPause: bool = false
@onready var eventAnim: Node2D = $SubViewport/eventAnim
@onready var eventName: Label = $SubViewport/eventAnim/eventName
@onready var eventStory: Label = $SubViewport/eventAnim/eventStory
@onready var eventEffect: Label = $SubViewport/eventAnim/eventEffect
var lastSpaceEffect: Vector2


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
		spinner.spin()
		canSpin = false
		money -= 1
		monUpdate()
		var rawSpin = spinSpinner()
		var spinResult: int = spinOps[rawSpin]
		
		if obtainedItems.has(5) and spinResult == 0:           #TODO
			var i = randi_range(0, 3)
			if i > 0:
				itemsActivating.clear()
				itemsActivating.append(5)
				itemActivate(itemsActivating)
				canSpin = true
				interpretSpin()
		
		
		roll_result.text = str(spinResult)                     #CULL
		
		
		var distance: int = spinResult
		
		
		if obtainedItems.has(0):
			var i = randi_range(0, 9)
			if i < 1:
				itemsActivating.clear()
				itemsActivating.append(0)
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
				await pauseForEvent()
				player.position = Vector2(player.position.x + playerDIR.x, player.position.y + playerDIR.y)
				
				await get_tree().create_timer(0.6).timeout
				distance -= 1
		eventPause = true
		spaceEvent()
	else:
		eventPause = true
		spaceEvent()


func pauseForEvent() -> void:

	while obtainablePause:
		
		fadeRect.color.a = lerpf(fadeRect.color.a, 0.5, 1)
		invItemInstance = invItem.instantiate()
		obtainableAnim()
		
		await get_tree().create_timer(3.5).timeout
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
	
	
	while eventPause:
		
		fadeRect.color.a = lerpf(fadeRect.color.a, 0.5, 1)
		eventAnim.show()
		triggerEvent()
		await get_tree().create_timer(3.5).timeout
		eventAnim.hide()
		fadeRect.color.a = lerpf(fadeRect.color.a, 0, 1)
		eventPause = false


func spaceEvent() -> void:
	randomize()
	var i = randi_range(0, 100)
	var spaceRarity
	if i >= 0 and i < 60:
		spaceRarity = 0
	if i >= 60 and i > 90:
		spaceRarity = 1
	if i >= 90 and i <= 100:
		spaceRarity = 2
	
	var s = randi_range(0, 5)
	match spaceRarity:
	
		0:                                  # Common Effects
			lastSpaceEffect.x = 0
			eventName.self_modulate = common
			match s:                   
				0:
					eventName.text = "Penny Pincher"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "You find a lonesome coin in the desolate maze. Better
							than nothing, right?"
						1:
							eventStory.text = "A corpse lies here, with a single shining coin in its
							rotting hand. You take it anyway, better yours than his."
						2:
							eventStory.text = "You find a suitcase full of money! Suddenly, an IRS 
							agent rounds the corner and takes away taxes, leaving a single coin in 
							revenue."
					eventEffect.text = "Gain 1 coin"
					eventEffect.self_modulate = positive
					lastSpaceEffect.y = 0
				1:
					eventName.text = "Cash Bonus"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "A few coins are strewn on the ground here. A nice haul
							in such an empty place."
						1:
							eventStory.text = "A bird flies in from above, dropping an envelope with
							your name on it - it's your royalties for your mixtape!"
						2:
							eventStory.text = "While digging through your pockets, you find some coins
							mixed with a wad of old gum. You've won, but at what cost?"
					eventEffect.text = "Gain 3 coins"
					eventEffect.self_modulate = positive
					lastSpaceEffect.y = 1
				2:
					eventName.text = "Extra Credit"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "An albatross swoops through and drops a letter from
							grandma - it's a birthday card! If only it wasn't 6 months late..."
						1:
							eventStory.text = "You stumble across a skeleton clutching a gold necklace.
							 Were you above grave robbing, it might have stayed that way..."
						2:
							eventStory.text = "You found a suitcase full of money! Suddenly, an IRS
							agent rounds the corner to take away taxes. You beat him to death before
							he takes it. Take that, taxes!"
					eventEffect.text = "Gain 6 coins"
					eventEffect.self_modulate = positive
					lastSpaceEffect.y = 2
				3:
					eventName.text = "The Classic Blunder"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "While admiring your coinage, you fumble your bag and
							drop one into the conveniently placed sewer grate. Way to go."
						1:
							eventStory.text = "Digging through your pockets, you find a hole through
							which a coin falls into a conveniently placed vat of acid you didn't realize
							was there. Nice job."
						2:
							eventStory.text = "Trumpets bellow from the sky - The Reckoning is nigh! A
							booming voice demands you discard you earthly means and close your eyes. As you
							do, you hear scuttling, and upon opening opening your eyes realize 3 goblins
							with a megaphone are digging through your wallet. They make off with your
							depressingly empty wallet. Idiot."
					eventEffect.text = "Lose 1 coin"
					eventEffect.self_modulate = negative
					lastSpaceEffect.y = 3
				4:
					eventName.text = "Taxes and.. What Else?"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "A pelican flies through, dropping your credit card bill. 
							Even here, there is no escape"
						1:
							eventStory.text = ""
						2:
							eventStory.text = ""
					eventEffect.text = "Lose 3 coins"
					eventEffect.self_modulate = negative
					lastSpaceEffect.y = 4
				5:
					eventName.text = "event5"
					eventStory.text = ""
					eventEffect.text = ""
					lastSpaceEffect.y = 5
		
		1:                                 # Rare Effects
			lastSpaceEffect.x = 1
			eventName.self_modulate = rare
			match s:                   
				0:
					eventName.text = "event0"
					eventStory.text = ""
					eventEffect.text = ""
					lastSpaceEffect.y = 0
				1:
					eventName.text = "event1"
					eventStory.text = ""
					eventEffect.text = ""
					lastSpaceEffect.y = 1
				2:
					eventName.text = "event2"
					eventStory.text = ""
					eventEffect.text = ""
					lastSpaceEffect.y = 2
				3:
					eventName.text = "event3"
					eventStory.text = ""
					eventEffect.text = ""
					lastSpaceEffect.y = 3
				4:
					eventName.text = "event4"
					eventStory.text = ""
					eventEffect.text = ""
					lastSpaceEffect.y = 4
	
		2:                                 # UltraRare Effects
			lastSpaceEffect.x = 2
			eventName.self_modulate = ultraRare
			match s:                   
				0:
					eventName.text = "event0"
					eventStory.text = ""
					eventEffect.text = ""
					lastSpaceEffect.y = 0
				1:
					eventName.text = "event1"
					eventStory.text = ""
					eventEffect.text = ""
					lastSpaceEffect.y = 1
				2:
					eventName.text = "event2"
					eventStory.text = ""
					eventEffect.text = ""
					lastSpaceEffect.y = 2
				3:
					eventName.text = "event3"
					eventStory.text = ""
					eventEffect.text = ""
					lastSpaceEffect.y = 3
				4:
					eventName.text = "event4"
					eventStory.text = ""
					eventEffect.text = ""
					lastSpaceEffect.y = 4
	
	await pauseForEvent()
	canSpin = true
	eventPause = false


func triggerEvent() -> void:
	match lastSpaceEffect:
		pass


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
	pauseForEvent()



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
