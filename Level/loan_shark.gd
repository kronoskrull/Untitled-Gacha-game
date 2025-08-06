extends Node2D

@onready var level: Node3D = $"../.."
var endX: float = 1000.0
var startPos: float = -200
var lerpSpeed: float = 5
var entering: bool = false
var exiting: bool = false
@onready var target_node: Node2D = $targetNode
@onready var sprite: Sprite2D = $"Loanshark-final"

@onready var curFrame: int = 0

var interactions: int = 0
var dialogueStartPos: int = 0

@onready var dialogue_skip_button: Button = $"../../Control/dialogueSkipButton"

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	sprite.frame = curFrame

func _physics_process(delta: float) -> void:
	
	if entering:
		position.x = lerpf(position.x, target_node.position.x, lerpSpeed * delta)
		if position.x > target_node.position.x - 10.0:
			position.x = target_node.position.x
			entering = false

	
	if exiting:
		position.x = lerpf(position.x, startPos, lerpSpeed * delta)
		if position.x < startPos + 10.0:
			position.x = startPos
			exiting = false

func exit():
	if !entering:
		entering = false
		exiting = true
		level.deltaMoney = 10 + abs(level.money)
		level.monUpdate(level.deltaMoney)
		level.canSpin = true
		dialogue_skip_button.hide()

func enter():
	if !exiting:
		entering = true
		exiting = false

func get_dialogue_start_pos() -> int:
	level.canSpin = false
	dialogue_skip_button.show()
	if interactions == 0:
		dialogueStartPos = 0
		interactions += 1
	elif interactions == 1:
		dialogueStartPos = 12
		interactions += 1
	else:
		var x = randi_range(0, 4)
		match x:
			0:
				dialogueStartPos = 21
			1:
				dialogueStartPos = 33
			2:
				dialogueStartPos = 12
			3:
				dialogueStartPos = 12
			4:
				dialogueStartPos = 12
	return dialogueStartPos


func change_frame(frame: int) -> void:
	$"Loanshark-final".frame = frame
