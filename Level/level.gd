extends Node3D


@export var eUtils: eventUtils

@onready var player: Node2D = $SubViewport/player
var playerDIR: Vector2 = Vector2(0, 32)
@onready var curDIRLabel: Label = $Control/debugPanel/VBoxContainer/curDIRlabel/curDIR

var obtainablePause: bool = false
@onready var fadeRect: ColorRect = $SubViewport/fadeRect

var canSpin: bool = true
@onready var spinner: CSGCylinder3D = $"lighting & env/spinnerPLACEHOLDER"

var spinOptions: spinTables = spinTables.new()
var effectOps: Array = spinOptions.spinOpTable



var obtainedItems: Array = []

@export var money: int = 5
var deltaMoney: int = 0
@onready var money_label: Label = $SubViewport/coinNumber/statusSprite/moneyLabel

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
@onready var invItem = preload("res://Level/invItem.tscn")
@onready var invSeparator = preload("res://Level/inv_separator.tscn")
@onready var inventory: VBoxContainer = $inv/inventoryPanel/VBoxContainer
var invItemInstance
var invSeparatorInstance
var rarity: Color

var positive: Color = Color.LAWN_GREEN
var negative: Color = Color.RED
var unique: Color = Color.GOLD

var common: Color = Color.GREEN_YELLOW
var rare: Color = Color.SKY_BLUE
var ultraRare: Color = Color.DARK_MAGENTA

var chanceNegIncrease: bool = false
var savingsAcc: bool = false
var coinsSaved: int = 0

var rareSpaceCoinLoss: bool = false
var ultraSpaceCoinGain: bool = false
var ultraSpaceCoinLoss: bool = false

var doubleChance: int = 1
var insured: bool = false
var scottFree: bool = false
var eventPause: bool = false
@onready var eventAnim: Node2D = $SubViewport/eventAnim
@onready var eventName: Label = $SubViewport/eventAnim/eventName
@onready var eventStory: Label = $SubViewport/eventAnim/eventStory
@onready var eventEffect: Label = $SubViewport/eventAnim/eventEffect
@onready var eventSprite: Sprite2D = $SubViewport/eventAnim/eventSprite
@onready var anims: AnimationPlayer = $SubViewport/eventAnim/AnimationPlayer

@onready var statusSprite1_0: Control = $"SubViewport/status/PanelContainer/1-0/statusSprite"
@onready var statusSprite1_2: Control = $"SubViewport/status/PanelContainer/1-2/statusSprite"
@onready var statusSprite1_3: Control = $"SubViewport/status/PanelContainer/1-3/statusSprite"
@onready var statusSprite1_5: Control = $"SubViewport/status/PanelContainer/1-5/statusSprite"
@onready var statusSprite2_2: Control = $"SubViewport/status/PanelContainer/2-2/statusSprite"
@onready var statusSprite2_4: Control = $"SubViewport/status/PanelContainer/2-4/statusSprite"


@onready var spinner_slot_0: Control = $Control/spinnerMenu/spinnerSlot0
@onready var spinner_slot_1: Control = $Control/spinnerMenu/spinnerSlot1
@onready var spinner_slot_2: Control = $Control/spinnerMenu/spinnerSlot2
@onready var spinner_slot_3: Control = $Control/spinnerMenu/spinnerSlot3
@onready var spinner_slot_4: Control = $Control/spinnerMenu/spinnerSlot4
@onready var spinner_slot_5: Control = $Control/spinnerMenu/spinnerSlot5
@onready var spinner_slot_6: Control = $Control/spinnerMenu/spinnerSlot6
@onready var spinner_slot_7: Control = $Control/spinnerMenu/spinnerSlot7
@onready var spinner_slot_8: Control = $Control/spinnerMenu/spinnerSlot8
@onready var spinner_slot_9: Control = $Control/spinnerMenu/spinnerSlot9

@onready var spinOps: Array = [spinner_slot_0, spinner_slot_1, spinner_slot_2, spinner_slot_3, spinner_slot_4, 
spinner_slot_5, spinner_slot_6, spinner_slot_7, spinner_slot_8, spinner_slot_9]

var lastSpaceEffect: Vector2

var debugSelect
var debugRarity: int = 0
var debugX: int

var flashMult: float = 4.0


@onready var audioPlayer: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var spin_1Player: AudioStreamPlayer3D = $spin1
@onready var spin_2Player: AudioStreamPlayer3D = $spin2


@onready var loan_shark: CharacterBody2D = $SubViewport/loanShark
var spinning: bool
@onready var spinSoundTimer: Timer = $spinSoundTimer

var chalMode: bool
var firstSpin: bool = true
var standPressed: int = 0
var serPress: int = 0


@onready var monUpdateTag = $SubViewport/coinNumber/statusSprite/moneyLabel/monUpdate
var ITEM_GET = preload("res://itemGet.tscn")
var itemGetInstance

func _ready() -> void:
	money_label.text = str(money)

func _process(delta: float) -> void:
	curDIRLabel.text = str(playerDIR)
	if canSpin:
		$"Control/1spinButton".show()
	else:
		$"Control/1spinButton".hide()

func monUpdate(Delta: int) -> void:
	money += Delta
	if Delta > 0:
		audioPlayer.stream = preload("res://Assets/Audio/90s-game-ui-6-185099.mp3")
		audioPlayer.play()
	
	money_label.text = (str(money))
	monUpdateTag.num = Delta
	monUpdateTag.show()
	monUpdateTag.deathTimer.start()
	
	deltaMoney = 0

# This is the functio that will house the match table for all the different effects. When the function
# starts, it spins a random number 0 - 9 inclusive. This value is an index thatr corresponds to one of 
# the ten available positions on the player spinner.


func interpretSpin() -> void:
	if money > 0 and canSpin:
		if firstSpin:
			firstSpin = false
			$Control/itemMenu.hide()
		itemsActivating.clear()
		spin_1Player.play()
		spin_2Player.play()
		spinner.spin()
		canSpin = false
		spinning = true
		spinSoundTimer.start(2.0)
		deltaMoney -= 1
		monUpdate(deltaMoney)
		var rawSpin = spinSpinner()
		var getIndex = spinOps[rawSpin]
		getIndex.get_child(0).timesRolled += 1
		var spinResult: int = getIndex.get_child(0).index
		
		for x in obtainedItems:
			if x == 5 and spinResult == 0:
				var i = randi_range(doubleChance, 4)
				if i >= 4:
					itemsActivating.clear()
					itemsActivating.append(5)
					itemActivate(itemsActivating)
					canSpin = true
					interpretSpin()
		
		
		roll_result.text = str(spinResult)                     #CULL
		
		
		var distance: int = spinResult
		
		
		for i in obtainedItems:
			if i == 0:
				var x = randi_range(doubleChance, 10)
				if x >= 10:
					itemsActivating.append(0)
					distance += 1
		
		for i in obtainedItems:
			if i == 3:
				itemsActivating.append(3)
				distance += 1
			
		
		for i in obtainedItems:
			if i == 6:
				itemsActivating.append(6)
				distance += 3
		
		itemActivate(itemsActivating)
		move(distance)

func itemActivate(items: Array) -> void:
	for c in inventory.get_children():
		if items.has(c.index):
			c.activate()
		await get_tree().create_timer(0.05).timeout

func move(distance: int) -> void:
	var locDistance: int = distance
	if locDistance > 0:
		for i in locDistance:
			i = locDistance
			if i > 0:
				await pauseForEvent()
				player.position = Vector2(player.position.x + playerDIR.x, player.position.y + playerDIR.y)
				audioPlayer.stream = preload("res://Assets/Audio/hitHurt (1).wav")
				audioPlayer.play()
				await get_tree().create_timer(0.6).timeout
				locDistance -= 1
			
		if rareSpaceCoinLoss:
			rareSpaceCoinLoss = false
			coinPerSpace(0, distance)
		if ultraSpaceCoinGain:
			ultraSpaceCoinGain = false
			coinPerSpace(1, distance)
		if ultraSpaceCoinLoss:
			ultraSpaceCoinLoss = false
			coinPerSpace(2, distance)
		
		eventPause = true
		spaceEvent()
	else:
		eventPause = true
		spaceEvent()

func coinPerSpace(type: int, distance: int) -> void:
	var locDistance: int
	match type:
		0:
			locDistance = distance / 2
			deltaMoney -= locDistance
			statusSprite1_3.status = 0
			statusSprite1_3.type = 3
		1:
			deltaMoney += distance
			statusSprite2_2.status = 0
			statusSprite2_2.type = 4
		2:
			deltaMoney -= distance
			statusSprite2_4.status = 0
			statusSprite2_4.type = 3
	
	if obtainedItems.has(4):
		var i = randi_range(doubleChance, 4)
		if i >= 4:
			deltaMoney *= 2
			itemsActivating.clear()
			itemsActivating.append(4)
			itemActivate(itemsActivating)
	monUpdate(deltaMoney)

func pauseForEvent() -> void:

	while obtainablePause:
		
		fadeRect.color.a = lerpf(fadeRect.color.a, 0.7, 1)
		
		obtainableAnim()
		
		await get_tree().create_timer(4.5).timeout
		fadeRect.color.a = lerpf(fadeRect.color.a, 0, 1)
		obtainedAnim.hide()
		itemAnims.stop()
		invItemInstance = invItem.instantiate()
		invSeparatorInstance = invSeparator.instantiate()
		inventory.add_child(invItemInstance)
		inventory.add_child(invSeparatorInstance)
		inventory.add_child(invSeparatorInstance)
		inventory.add_child(invSeparatorInstance)
		invItemInstance.z_index = 5
		invItemInstance.index = newItemIndex
		invItemInstance.itemName.text = itemName.text
		invItemInstance.itemName.self_modulate = Color(rarity)
		invItemInstance.itemSprite.texture = itemSprite.texture
		invItemInstance.descLabel.text = itemEffect.text
		invItemInstance.activateTipLabel.text = newActLabel
		
		obtainablePause = false
		continue
	
	
	while eventPause:
		fadeRect.color.a = lerpf(fadeRect.color.a, 0.7, 1)
		eventAnim.show()
		eventTrigger()
		await get_tree().create_timer(5).timeout
		eventSprite.hide()
		eventAnim.hide()
		fadeRect.color.a = lerpf(fadeRect.color.a, 0, 1)
		eventPause = false
		if money <= 0:
			loan_shark.enter()
	
	


# This function determines based on probability the rarity of the effect,
# then picks a random effect from that rarity. This system does not differentiate
# from positive or negative, as both have an equal chance of triggering. To this
# end, the number of positive and negative effects in a given rarity should stay
# roughly even, but as the number of effects increases this will become less of an
# issue.

# To add more effects, simply continue in the same format that the other effects
# are, adding the new effect to the end of the list.
func spaceEvent() -> void:
	randomize()
	var i = randi_range(0, 100)
	var spaceRarity
	if i >= 0 and i < 70:
		spaceRarity = 0
	if i >= 70 and i < 95:
		spaceRarity = 1
	if i >= 95 and i <= 100:
		spaceRarity = 2
	
	var s = randi_range(0, 5)
	if debugSelect:
		s = debugX
	if debugSelect:
		spaceRarity = debugRarity
	
	match spaceRarity:
	
		0:                                  # Common Effects
			lastSpaceEffect.x = 0
			eventName.self_modulate = common
			match s:                  
				0:        # +1
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
							revenue. Bummer."
					eventEffect.text = "Gain 1 coin"
					eventEffect.self_modulate = positive
					lastSpaceEffect.y = 0
				1:        # +2
					eventName.text = "Cash Bonus"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "A few coins are strewn on the ground here. A nice haul
							in such an empty place."
						1:
							eventStory.text = "An owl flies in from above, dropping an envelope with
							your name on it - it's your royalties for your mixtape!"
						2:
							eventStory.text = "While digging through your pockets, you find some coins
							mixed with a wad of old gum. You've won, but at what cost?"
					eventEffect.text = "Gain 2 coins"
					eventEffect.self_modulate = positive
					lastSpaceEffect.y = 1
				2:        # +3
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
							he can. Take that, taxes!"
					eventEffect.text = "Gain 3 coins"
					eventEffect.self_modulate = positive
					lastSpaceEffect.y = 2
				3:        # -1
					eventName.text = "A Minor Inconvenience"
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
							eventStory.text = "Trumpets bellow from above - The Rapture has come!...
							 for your wallet. Even God needs a buck sometimes."
					eventEffect.text = "Lose 1 coin"
					eventEffect.self_modulate = negative
					lastSpaceEffect.y = 3
				4:        # -2
					eventName.text = "Taxes and.. What Else?"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "A pelican flies through, dropping your credit card bill. 
							Even here, there is no escape."
						1:
							eventStory.text = "An emu accosts you. You throw a handful of your shiniest
							coins to distract it and make your escape."
						2:
							eventStory.text = "A passing seagull shits on your nicest shirt. Luckily, the
							dry cleaners is just ahead."
					eventEffect.text = "Lose 2 coins"
					eventEffect.self_modulate = negative
					lastSpaceEffect.y = 4
				5:        # -3
					eventName.text = "Defecit Spending"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "You discover crypto currency. Surely this will turn out well!"
						1:
							eventStory.text = "Passing by an arcade, you discover the hard way how
							 bad you are at claw machines."
						2:
							eventStory.text = "A brand new [insert fad here] is your new favorite thing!
							 You waste a shit ton of money on it and never touch it again."
					eventEffect.text = "Lose 3 coins."
					eventEffect.self_modulate = negative
					lastSpaceEffect.y = 5
		
		1:                                 # Rare Effects
			lastSpaceEffect.x = 1
			eventName.self_modulate = rare
			match s:                   
				0:        # Can't lose coins next time you would
					eventName.text = "Coinsurance"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "Who said wallet chains are out of style?"
						1:
							eventStory.text = "That quarter of your paycheck is finally paying off!"
						2:
							eventStory.text = "Nothing protects your personal space (and your wallet)
							better than a gun!"
					eventEffect.text = "Can't lose coins the next time you would"
					eventEffect.self_modulate = positive
					eventSprite.texture = preload("res://Assets/effects/eff1-0.png")
					anims.play("bob")
					eventSprite.show()
					lastSpaceEffect.y = 0
				1:        # +6 
					eventName.text = "Investment Opportunity"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "You check your $HITCOIN wallet..."
						1:
							eventStory.text = "You invested in an indie gacha game for a game jam, and
							somehow it wasn't half bad."
						2:
							eventStory.text = "You bought 10 shares in 'Bubba's Bathtub Moonshine'."
					eventEffect.text = "Gain 6 coins"
					eventEffect.self_modulate = positive
					lastSpaceEffect.y = 1
				2:        # Spend now, gain later
					eventName.text = "Savings Account"
					var x = randi_range(0, 2)
					if !savingsAcc:
						match x:
							0:
								eventStory.text = "Investing in victory..."
							1:
								eventStory.text = "A shady banker, a cardboard desk, and a painted sign...
								 surely this pays off!"
							2:
								eventStory.text = "Now, I know it sounds crazy, but i swear leaving your money
								under this conspicuously placed rock makes it magically double!"
						eventEffect.text = "Lose up to 5 coins now, for a positive bonus later..."
						eventEffect.self_modulate = negative
						eventSprite.texture = preload("res://Assets/effects/eff1-2.png")
						anims.play("bob")
						eventSprite.show()
						lastSpaceEffect.y = 2
					else:
						match x:
							0:
								eventStory.text = "... means playing the long game!"
							1:
								eventStory.text = "Who said banks couldn't be trusted?"
							2:
								eventStory.text = "Surely you'll put this money to good use, right?"
						eventEffect.text = "Gain double the coins you saved before!"
						eventEffect.self_modulate = positive
						lastSpaceEffect.y = 2
				3:        # Lose a coin for every other space (2 turns)
					eventName.text = "Delayed Detriment"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "Unbeknownst to you, a hole magically appears in your wallet..."
						1:
							eventStory.text = "Maybe Flex Seal isn't all it's cracked up to be..."
						2:
							eventStory.text = "Well if you don't like it, maybe you shouldn't have picked a road
							with so many tolls!"
					eventEffect.text = "Lose a coin for every other space you move on the next spin"
					eventEffect.self_modulate = negative
					eventSprite.texture = preload("res://Assets/effects/eff1-3.png")
					eventSprite.show()
					anims.play("bob")
					lastSpaceEffect.y = 3
				4:        # -6
					eventName.text = "Investment Opportunity"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "You check your $HITCOIN wallet..."
						1:
							eventStory.text = "Seems like your scam call center was more work than that
							Nigerian prince made it out to be..."
						2:
							eventStory.text = "You invested in a pyramid scheme. How could you have known
							they were actually building a pyramid?"
					eventEffect.text = "Lose 6 Coins"
					eventEffect.self_modulate = negative
					lastSpaceEffect.y = 4
				5:        # 1 in 3 to double next negative effect
					eventName.text = "Double Negative"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "A black cat under a ladder and a broken mirror... SURELY 
							that can only mean good things."
						1:
							eventStory.text = "You step on a crack. It's in God's hands now."
						2:
							eventStory.text = "You felt your sins crawling on your back."
					eventEffect.text = "1 in 3 chance to double the next negative effect"
					eventEffect.self_modulate = negative
					eventSprite.texture = preload("res://Assets/effects/eff1-5.png")
					eventSprite.show()
					anims.play("bob")
					lastSpaceEffect.y = 5
	
		2:                                 # UltraRare Effects
			lastSpaceEffect.x = 2
			eventName.self_modulate = ultraRare
			match s:                   
				0:       # 2x coins
					eventName.text = "Sellout"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "You give in to temptation and start promoting dropshipping
							 outlets. Shame on you."
						1:
							eventStory.text = "Who knew being a corporate yes-man could be so fulfilling?"
						2:
							eventStory.text = "You start working for EA. There is no redeeming factor to this."
					eventEffect.text = "Duplicate your coins, at the cost of your dignity"
					eventEffect.self_modulate = positive
					lastSpaceEffect.y = 0
				1:       # +10
					eventName.text = "Winfall"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "Stairs: 1, Grandma: 0. At least you're in the will."
						1:
							eventStory.text = "Insurance fraud never felt so good."
						2:
							eventStory.text = "In retrospect, we've always been friends, right?"
					eventEffect.text = "Gain 10 coins"
					eventEffect.self_modulate = positive
					lastSpaceEffect.y = 1
				2:       # Gain coin for every space you move (2 turns)
					eventName.text = "Money Trail"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "A trail of gold coins NEVER leads anywhere bad, right?"
						1:
							eventStory.text = "Ooh, piece of candy... ooh, piece of candy..."
						2:
							eventStory.text = "If I told you where leprachauns got their gold from, 
							you'd never want it again."
					eventEffect.text = "Gain a coin for every space you move on the next spin"
					eventEffect.self_modulate = positive
					lastSpaceEffect.y = 2
				3:       # 1/2 coins
					eventName.text = "Art Of The Deal"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "This is why I signed a prenup."
						1:
							eventStory.text = "Nobody escapes the IRS."
						2:
							eventStory.text = "Investing in NFT's REALLY didn't pay off."
					eventEffect.text = "Lose half your coins"
					eventEffect.self_modulate = negative
					lastSpaceEffect.y = 3
				4:       # Lose coin for every space you move (2 turns)
					eventName.text = "Highway Robbery"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "Go this way, you said. There's less tolls here, you said. This is
							 what you get for using Mapquest."
						1:
							eventStory.text = "A blue-footed booby flies through and drops an envelope with
							 an extensive record of your search history. You agree to his blackmail immediately."
						2:
							eventStory.text = "When I said that they'd 'garnish your bread', I wasn't talking about food."
					eventEffect.text = "Lose a coin for every space you move on your next spin"
					eventEffect.self_modulate = negative
					lastSpaceEffect.y = 4
				5:       # Enrichment Module
					eventName.text = "ENRICHMENT MODULE"
					var x = randi_range(0, 2)
					match x:
						0:
							eventStory.text = "Please enjoy the ENRICHMENT MODULE!"
						1:
							eventStory.text = "Thank you for your 'voluntary' participation in the testing of the 
							ENRICHMENT MODULE!"
						2:
							eventStory.text = "ENRICHMENT MODULE!"
					eventEffect.text = "100% chance of increased enrichment! (not a peer reviewed statistic)"
					eventEffect.self_modulate = unique
					lastSpaceEffect.y = 5
	
	await pauseForEvent()
	canSpin = true
	eventPause = false
	debugSelect = false


# Get the latest space event, then get its related modifier info. Then, iterate through the list.
# For all effects in a given event's eventInfo, go through them and apply them if they
# are applicable. To force specific modifiers to trigger before certain events, the
# event itself is a modifier tied to a match statement for each event Vector2, and tied
# to the match int 999

func eventTrigger() -> void:
	var event: Vector2 = lastSpaceEffect
	var eventInfo: Array = eUtils.eventID[str(event)]
	var locDeltaMoney: int = 0
	
	# Iterate through the event's modifiers, then apply it appropriately
	itemsActivating.clear()
	for m in eventInfo:
		match m:
			999:
				match event:
					Vector2(0, 0):            # Common
						locDeltaMoney += 1
					Vector2(0, 1):
						locDeltaMoney += 2
					Vector2(0, 2):
						locDeltaMoney += 3
					Vector2(0, 3):
						locDeltaMoney -= 1
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					Vector2(0, 4):
						locDeltaMoney -= 2
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					Vector2(0, 5):
						locDeltaMoney -= 3
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					
					Vector2(1, 0):           # Rare
						insured = true
						statusSprite1_0.status = 1
					Vector2(1, 1):
						locDeltaMoney += 6
					Vector2(1, 2):
						if !savingsAcc:
							coinsSaved = 0
							coinsSaved = randi_range(money, 5)
							if coinsSaved > 5:
								coinsSaved = 5
							locDeltaMoney -= coinsSaved
							savingsAcc = true
							statusSprite1_2.status = 1
						else:
							locDeltaMoney += (coinsSaved * 2)
							savingsAcc = false
							statusSprite1_2.status = 0
							statusSprite1_2.type = 2
					Vector2(1, 3):
						rareSpaceCoinLoss = true
						statusSprite1_3.status = 1
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					Vector2(1, 4):
						locDeltaMoney -= 6
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					Vector2(1, 5):
						chanceNegIncrease = true
						statusSprite1_5.status = 1
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					
					Vector2(2, 0):            # Ultra Rare
						locDeltaMoney = money * 2
					Vector2(2, 1):
						locDeltaMoney += 10
					Vector2(2, 2):
						ultraSpaceCoinGain = true
						statusSprite2_2.status = 1
					Vector2(2, 3):
						locDeltaMoney -= (money / 2)
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					Vector2(2, 4):
						ultraSpaceCoinLoss = true
						statusSprite2_4.status = 1
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					Vector2(2, 5):
						pass
						
			0: # LUCKY BREAK
					for i in obtainedItems:
						if i == 1:
							var x = randi_range(doubleChance, 5)
							if x >= 5:
								locDeltaMoney += 1
								itemsActivating.append(1)
								
			1: # NEGATIVE NEGATION
				for i in obtainedItems:
					if i == 2:
						var x = randi_range(doubleChance, 15)
						if x >= 15:
							locDeltaMoney = 0
							eventEffect.text = "EFFECT NEGATED"
							eventInfo.erase(999)
							itemsActivating.append(2)
							
			2: # BANK ERROR
				for i in obtainedItems:
					if i == 4:
						var x = randi_range(doubleChance, 4)
						if x >= 4:
							locDeltaMoney *= 2
							itemsActivating.append(4)
							
			3: # SCOT-FREE
				if scottFree:
					locDeltaMoney -= 10
					itemsActivating.append(8)
					eventEffect.text = "EFFECT NEGATED"
					eventInfo.erase(999)
					eventInfo.erase(2)
					
			4: # COINSURANCE
				if insured:
					insured = false
					statusSprite1_0.status = 0
					statusSprite1_0.type = 0
					eventEffect.text = "EFFECT NEGATED"
					eventInfo.erase(3)
					eventInfo.erase(2)
					eventInfo.erase(999)
					
			5: # DOUBLE NEGATIVE
				if chanceNegIncrease:
					var x = randi_range(doubleChance, 3)
					if x >= 3:
						chanceNegIncrease = false
						statusSprite1_5.status = 0
						statusSprite1_5.type = 5
						eventTrigger()
					else:
						chanceNegIncrease = false
						statusSprite1_5.status = 0
						statusSprite1_5.type = 1
	
	monUpdate(locDeltaMoney)
	itemActivate(itemsActivating)

#region Obtainables Stuff
func obtainableAnim():
	
	match lastObtained:
		0:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt001.png"))
			itemName.text = "Leg Day"
			itemEffect.text = "1 in 10 chance to move an extra space"
			itemEffect.self_modulate = common
			itemName.self_modulate = common
			commentLabel.text = "Maybe hitting the gym isn't such a bad idea"
			newActLabel = "+1 to roll... maybe!"
			rarity = common
		1:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt002.png"))
			itemName.text = "Lucky Break"
			itemEffect.text = "1 in 5 chance for +1 coins when you obtain coins"
			itemEffect.self_modulate = common
			itemName.self_modulate = common
			commentLabel.text = "A one-leaf clover HAS to be lucky sometime, right?"
			newActLabel = "+1 coin!"
			rarity = common
		2:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt003.png"))
			itemName.text = "Negative Negation"
			itemEffect.text = "1 in 15 chance to negate a negative space effect"
			itemEffect.self_modulate = common
			itemName.self_modulate = common
			commentLabel.text = "If I can't see it, it doesn't exist!"
			newActLabel = "Effect Negated!"
			rarity = common
		3:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt004.png"))
			itemName.text = "Leg Day+"
			itemEffect.text = "Adds 1 to every spin"
			itemEffect.self_modulate = rare
			itemName.self_modulate = rare
			commentLabel.text = "Those gains are really paying off, huh?"
			newActLabel = "+1 to roll!"
			rarity = rare
		4:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt005.png"))
			itemName.text = "Bank Error"
			itemEffect.text = "When gaining/losing coins, 1 in 4 chance to double the amount"
			itemEffect.self_modulate = rare
			itemName.self_modulate = rare
			commentLabel.text = "Bank error in your favor (or not)"
			newActLabel = "ERR0R"
			rarity = rare
		5:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt006.png"))
			itemName.text = "Anywhere But Here!"
			itemEffect.text = "1 in 4 chance to reroll every 0"
			itemEffect.self_modulate = rare
			itemName.self_modulate = rare
			commentLabel.text = "We've all cheated at least once, right?"
			newActLabel = "Reroll!"
			rarity = rare
		6:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt007.png"))
			itemName.text = "Leg Day++"
			itemEffect.text = "Adds 3 to every spin"
			itemEffect.self_modulate = ultraRare
			itemName.self_modulate = ultraRare
			commentLabel.text = "What are they putting in your pre-workout, dude?!"
			newActLabel = "+3 to roll!"
			rarity = ultraRare
		7:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt008.png"))
			itemName.text = "Loaded Dice"
			itemEffect.text = "Doubles all odds"
			itemEffect.self_modulate = ultraRare
			itemName.self_modulate = ultraRare
			commentLabel.text = "If you want a guarantee, buy a toaster. Or take this item, either works."
			rarity = ultraRare
			doubleChanceInc()
		8:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt009.png"))
			itemName.text = "Scot-Free"
			itemEffect.text = "Pay 10 coins to negate a negative space effect"
			itemEffect.self_modulate = ultraRare
			itemName.self_modulate = ultraRare
			commentLabel.text = "Just like in real life!"
			newActLabel = "Consequences Escaped!"
			rarity = ultraRare
			scottFree = true
		9:
			itemSprite.set_texture(preload("res://Assets/obtainables/obt001.png"))
			itemName.text = "Multiroll"
			itemEffect.text = "Roll 3 times, last roll upgrades the space effect!"
			itemEffect.self_modulate = unique
			itemName.self_modulate = unique
			commentLabel.text = "This is where the fun begins!"
			newActLabel = "Multiroll!"
	
	audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-24-229496.mp3")
	audioPlayer.play()
	obtainedAnim.show()
	itemAnims.play("blink_bob")

func doubleChanceInc() -> void:
	doubleChance *= 2

func getObtainable(obtainable: int) -> void:
	newItemIndex = obtainable
	obtainedItems.append(obtainable)
	lastObtained = obtainable
	pauseForEvent()
#endregion

#region Buttons
func spinSpinner() -> int:
	var spinResult: int
	
	spinResult = randi_range(0, 9)
	
	return spinResult

func _on_spin_button_pressed() -> void:
	interpretSpin()

func _on_resetbutton_pressed() -> void:
	get_tree().reload_current_scene()

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


func _on_spin_sound_timer_timeout() -> void:
	spinning = false
	spin_1Player.stop()
	spin_1Player.volume_db = 3

#endregion

func changeSharkFrame(frame: int) -> void:
	loan_shark.curFrame = frame

func cull_system():
	for c in $".".get_children(false):
		if c.is_in_group("dialogue_system"):
			c.segmented_cull()

func bootUp(chal: bool) -> void:
	chalMode = chal
	$outerFadeRect/AnimationPlayer.play("fade")
	$Camera3D/AnimationPlayer.play("gotoPlay")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"fade":
			inventory.show()
			$Control.show()
			$SubViewport/Maze1_0.show()
			$SubViewport/coinNumber.show()
			$inv.show()
			$"lighting & env/lights/hideLights".show()
			
			fadeRect.color.a = 0.0
			$ambience1.play()
			$outerFadeRect/AnimationPlayer.play("return")
			if chalMode:
				for c in $"lighting & env/lights/modeLights".get_children(false):
					c.light_color = Color.RED
				$Control/itemMenu.show()
				money = money * 2
				$SubViewport/coinNumber/statusSprite/moneyLabel.text = str(money)

func _on_standard_mode_pressed() -> void:
	$Menu/AudioStreamPlayer2D.play()
	$Menu/subOptions/VBoxContainer/standardMode/buttonSprite/AnimationPlayer.play("pressed")
	standPressed += 1
	serPress = 0
	$Menu/warningLabel.hide()
	if standPressed >= 1:
		audioPlayer.stream = preload("res://Assets/Audio/game-start-317318.mp3")
		audioPlayer.play()
		for c in $SubViewport/obtainables.get_children():
			c.enable()
		bootUp(false)
		$Menu.hide()


func _on_challenge_mode_pressed() -> void:
	$Menu/AudioStreamPlayer2D.play()
	$Menu/subOptions/VBoxContainer/challengeMode/buttonSprite/AnimationPlayer.play("pressed")
	if standPressed >= 0 and $"lighting & env/lights/modeLights/SpotLight3D3".light_color != Color.RED:
		$"lighting & env/lights/modeLights/SpotLight3D3/AnimationPlayer".play("colorSwap")
		$"lighting & env/lights/modeLights/SpotLight3D4/AnimationPlayer2".play("colorSwap")
	serPress += 1
	standPressed = 0
	if serPress >= 1:
		$Menu/warningLabel.show()
	if serPress >= 2:
		audioPlayer.stream = preload("res://Assets/Audio/evilLaughChurchBellUpdated.mp3")
		audioPlayer.play()
		for c in $SubViewport/obtainables.get_children():
			c.disable()
		$SubViewport/obtainables.hide()
		chalMode = true
		$Menu.hide()
		bootUp(true)


func _on_dialogue_skip_button_pressed() -> void:
	cull_system()
