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
		level.money = 10
		level.monUpdate(level.deltaMoney)

func enter():
	if !exiting:
		entering = true
		exiting = false


func change_frame(frame: int) -> void:
	$"Loanshark-final".frame = frame
