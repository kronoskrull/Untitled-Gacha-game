extends Node3D


@export var eUtils: eventUtils
@export var obtDatabase: Script
@export var spaceDatabase: Script

@onready var player: Node2D = $SubViewport/player
var playerDIR: Vector2 = Vector2(0, 32)
@onready var curDIRLabel: Label = $Control/debugPanel/VBoxContainer/curDIRlabel/curDIR

var obtainablePause: bool = false
@onready var fadeRect: ColorRect = $SubViewport/fadeRect

var canSpin: bool = true
@onready var spinner: CSGCylinder3D = $"lighting & env/spinnerPLACEHOLDER"

var spinResult: int = 0
var spinOptions: spinTables = spinTables.new()
var effectOps: Array = spinOptions.spinOpTable



var obtainedItems: Array = []

@export var money: int = 5
var deltaMoney: int = 0
@onready var money_label: Label = $SubViewport/coinNumber/statusSprite/moneyLabel

@onready var roll_result: Label = $Control/rollResult/Sprite2D/resultLabel
@onready var rollResult: Control = $Control/rollResult



var lastObtained: Array
@onready var itemSprite: Sprite2D = $SubViewport/obtainedAnim/itemSprite
@onready var itemAnims: AnimationPlayer = $SubViewport/obtainedAnim/AnimationPlayer
@onready var itemName: Label = $SubViewport/obtainedAnim/itemname
@onready var itemEffect: Label = $SubViewport/obtainedAnim/itemEffect
@onready var commentLabel: Label = $SubViewport/obtainedAnim/commentLabel
@onready var obtainedAnim: Node2D = $SubViewport/obtainedAnim
var itemsActivating: Array = [0]
var newItem: Array
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

var lastSpaceEffect: Array

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

var event_popup_up := false
var event_queued := false
var item_popup_up := false
var item_queued := false

@onready var monUpdateTag = $SubViewport/coinNumber/statusSprite/moneyLabel/monUpdate
var ITEM_GET = preload("res://itemGet.tscn")
var itemGetInstance

func _ready() -> void:
	money_label.text = str(money)

func _process(delta: float) -> void:
	curDIRLabel.text = str(playerDIR)
	if canSpin:
		$"Control/spinButton".show()
	else:
		$"Control/spinButton".hide()
	
	roll_result.text = str(spinResult)                     #CULL
	
	if Input.is_action_pressed("interact"):
		if item_popup_up:
			end_item_popup()
		if event_popup_up:
			end_event_popup()

func monUpdate(Delta: int) -> void:
	money += Delta
	if Delta > 0:
		audioPlayer.stream = preload("res://Assets/Audio/90s-game-ui-6-185099.mp3")
		audioPlayer.play()
	
	if Delta != 0:
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
		rollResult.show()
		spinSoundTimer.start(2.0)
		deltaMoney -= 1
		monUpdate(deltaMoney)
		var rawSpin = spinSpinner()
		var getIndex = spinOps[rawSpin]
		getIndex.get_child(0).timesRolled += 1
		var spinResult: int = getIndex.get_child(0).index
		
		
		if obtainedItems.has("Anywhere But Here") and spinResult == 0:
			var i = randi_range(doubleChance, 4)
			if i >= 4:
				itemsActivating.clear()
				itemsActivating.append(5)
				itemActivate(itemsActivating)
				canSpin = true
				interpretSpin()
		
		var distance: int = spinResult
		
		if obtainedItems.has("Leg Day"):
			var x = randi_range(doubleChance, 10)
			if x >= 10:
				itemsActivating.append(0)
				distance += 1
		
		if obtainedItems.has("Leg Day+"):
			itemsActivating.append(3)
			distance += 1
		
		if obtainedItems.has("Leg Day++"):
			itemsActivating.append(6)
			distance += 3
		
		itemActivate(itemsActivating)
		
		if distance > 0:
			move(distance)
		else:
			
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

func itemActivate(items: Array) -> void:
	for c in inventory.get_children():
		if items.has(c):
			c.activate()
		await get_tree().create_timer(0.05).timeout

func move(distance: int) -> void:
	var locDistance: int = distance
	
	for i in locDistance:
		var x = locDistance
		if x > 0:
			if item_queued:
				item_queued = false
				item_popup_up = true
				pause_for_item()
			if event_queued:
				event_queued = false
				event_popup_up = true
				pauseForEvent()
			
			if !item_popup_up:
				move_next_space()
				
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

func move_next_space() -> void:
	player.position = Vector2(player.position.x + playerDIR.x, player.position.y + playerDIR.y)
	audioPlayer.stream = preload("res://Assets/Audio/hitHurt (1).wav")
	audioPlayer.play()
	

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
	fadeRect.color.a = lerpf(fadeRect.color.a, 0.7, 1)
	eventAnim.show()
	eventTrigger()

func end_event_popup() -> void:
	event_popup_up = false
	canSpin = true
	debugSelect = false
	eventSprite.hide()
	eventAnim.hide()
	fadeRect.color.a = lerpf(fadeRect.color.a, 0, 1)
	eventPause = false
	if money <= 0:
		loan_shark.enter()

func pause_for_item() -> void:
	item_queued = false
	item_popup_up = true
	fadeRect.color.a = lerpf(fadeRect.color.a, 0.7, 1)
	obtainableAnim()

func end_item_popup() -> void:
	if item_popup_up:
		item_popup_up = false
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
		invItemInstance.itemName.text = itemName.text
		invItemInstance.itemName.self_modulate = Color(rarity)
		invItemInstance.itemSprite.texture = itemSprite.texture
		invItemInstance.descLabel.text = itemEffect.text
		invItemInstance.activateTipLabel.text = newActLabel
		
		if event_queued:
			event_queued = false
			pauseForEvent()

## Pick a random event from the database and flags it to trigger the popup
func spaceEvent() -> void:
	randomize()
	var i = randi_range(0, 100)
	
	
	if i >= 0 and i < 70:
		lastSpaceEffect = spaceDatabase.COMMON.pick_random()
		eventName.self_modulate = common
	if i >= 70 and i < 95:
		lastSpaceEffect = spaceDatabase.RARE.pick_random()
		eventName.self_modulate = rare
	if i >= 95 and i <= 100:
		lastSpaceEffect = spaceDatabase.ULTRA.pick_random()
		eventName.self_modulate = ultraRare
	
	eventName.text = lastSpaceEffect[0]
	eventStory.text = lastSpaceEffect[1].pick_random()
	eventEffect.text = lastSpaceEffect[2]
	
	match lastSpaceEffect[3]:
		"positive":
			eventEffect.self_modulate = positive
		"negative":
			eventEffect.self_modulate = negative
		"unique":
			eventEffect.self_modulate = unique
	
	event_popup_up = true
	pauseForEvent()


# Get the latest space event, then get its related modifier info. Then, iterate through the list.
# For all effects in a given event's eventInfo, go through them and apply them if they
# are applicable. To force specific modifiers to trigger before certain events, the
# event itself is a modifier tied to a match statement for each event Vector2, and tied
# to the match int 999

func eventTrigger() -> void:
	var event: Array = lastSpaceEffect
	var event_name = lastSpaceEffect[0]
	var eventInfo: Array = eUtils.eventID[str(event[0])]
	var locDeltaMoney: int = 0
	# Iterate through the event's modifiers, then apply it appropriately
	itemsActivating.clear()
	for m in eventInfo:
		match m:
			999:
				match event_name:
					"Penny Pincher":            # Common
						locDeltaMoney += 1
					"Cash Bonus":
						locDeltaMoney += 2
					"Extra Credit":
						locDeltaMoney += 3
					"A Minor Inconvenience":
						locDeltaMoney -= 1
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					"Taxes and.. What Else?":
						locDeltaMoney -= 2
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					"Defecit Spending":
						locDeltaMoney -= 3
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					
					"Coinsurance":           # Rare
						insured = true
						statusSprite1_0.status = 1
					"Investment Opportunity: Positive":
						locDeltaMoney += 6
					"Savings Account I":
						coinsSaved = 0
						coinsSaved = randi_range(money, 5)
						if coinsSaved > 5:
							coinsSaved = 5
						locDeltaMoney -= coinsSaved
						savingsAcc = true
						statusSprite1_2.status = 1
					"Savings Account II":
						locDeltaMoney += (coinsSaved * 2)
						savingsAcc = false
						statusSprite1_2.status = 0
						statusSprite1_2.type = 2
					"Delayed Detriment":
						rareSpaceCoinLoss = true
						statusSprite1_3.status = 1
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					"Investment Opportunity: Negative":
						locDeltaMoney -= 6
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					"Double Negative":
						chanceNegIncrease = true
						statusSprite1_5.status = 1
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					
					"Sellout":            # Ultra Rare
						locDeltaMoney = money * 2
					"Winfall":
						locDeltaMoney += 10
					"Money Trail":
						ultraSpaceCoinGain = true
						statusSprite2_2.status = 1
					"Art Of The Deal":
						locDeltaMoney -= (money / 2)
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					"Highway Robbery":
						ultraSpaceCoinLoss = true
						statusSprite2_4.status = 1
						audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-28-229497.mp3")
						audioPlayer.play()
					"ENRICHMENT MODULE":
						pass
						
			0: # LUCKY BREAK
					if obtainedItems.has("Lucky Break"):
						var x = randi_range(doubleChance, 5)
						if x >= 5:
							locDeltaMoney += 1
							itemsActivating.append(1)
								
			1: # NEGATIVE NEGATION
				if obtainedItems.has("Negative Negation"):
					var x = randi_range(doubleChance, 15)
					if x >= 15:
						locDeltaMoney = 0
						eventEffect.text = "EFFECT NEGATED"
						eventInfo.erase(999)
						itemsActivating.append(2)
							
			2: # BANK ERROR
				if obtainedItems.has("Bank Error"):
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
	
	itemSprite.set_texture(lastObtained[0])
	itemName.text = lastObtained[1]
	itemEffect.text = lastObtained[2]
	commentLabel.text = lastObtained[5]
	newActLabel = lastObtained[6]
	
	match lastObtained[3]:
		"common":
			itemEffect.self_modulate = common
			itemName.self_modulate = common
		"rare":
			itemEffect.self_modulate = rare
			itemName.self_modulate = rare
		"ultraRare":
			itemEffect.self_modulate = ultraRare
			itemName.self_modulate = ultraRare
	
	if lastObtained.has("Loaded Dice"):
		doubleChanceInc()
	if lastObtained.has("Scot-Free"):
		scottFree = true
	
	audioPlayer.stream = preload("res://Assets/Audio/arcade-ui-24-229496.mp3")
	audioPlayer.play()
	obtainedAnim.show()
	itemAnims.play("blink_bob")


func getObtainable(obtainable: Array) -> void:
	newItem = obtainable
	obtainedItems.append(obtainable[1])
	lastObtained = obtainable
	item_queued = true


func doubleChanceInc() -> void:
	doubleChance *= 2

#endregion

#region Buttons
func spinSpinner() -> int:
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
	rollResult.hide()
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
