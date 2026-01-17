extends Node2D

@export var obtDatabase : Script

var spintables = spinTables.new()
@onready var masterObTable: Array = spintables.masterObtainableTable
@onready var anims: AnimationPlayer = $AnimationPlayer

var canBeObtained: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anims.play("obtBob")

func disable():
	$Area2D.monitoring = false

func enable():
	$Area2D.monitoring = true

# Choose
func _on_area_2d_area_entered(area: Area2D) -> void:
	if canBeObtained:
		canBeObtained = false
		var player = area.get_parent().get_parent().get_parent()
		
		player.obtainablePause = true
		
		var rarity = randi_range(1, 100)
		var randIndex: int
		var obtainable: Array
		
		if rarity <= 60:                                            # Common obtainable
			obtainable = obtDatabase.COMMON.pick_random()
			
		if rarity > 60 and rarity <= 90:                            # Rare obtainable
			obtainable = obtDatabase.RARE.pick_random()
			
		if rarity > 90 and rarity <= 100:                           # Ultra obtainable
			obtainable = obtDatabase.ULTRA.pick_random()
			
		
		player.getObtainable(obtainable)
		queue_free()
