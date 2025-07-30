extends Node2D

var spintables = spinTables.new()
@onready var masterObTable: Array = spintables.masterObtainableTable
@onready var anims: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anims.play("obtBob")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Choose
func _on_area_2d_area_entered(area: Area2D) -> void:
	
	var player = area.get_parent().get_parent().get_parent()
	
	player.obtainablePause = true
	
	var rarity = randi_range(1, 100)
	var randIndex: int
	
	if rarity <= 60:                                            # Common obtainable
		randIndex = randi_range(0, spintables.commonObMaxIndex)
		
	if rarity > 60 and rarity <= 90:                            # Rare obtainable
		randIndex = randi_range(spintables.commonObMaxIndex + 1, spintables.rareObMaxIndex)
		
	if rarity > 90 and rarity <= 100:                           # Ultra obtainable
		randIndex = randi_range(spintables.rareObMaxIndex + 1, spintables.ultraObMaxIndex)
		
	
	var obtainable: int = masterObTable[randIndex]
	player.getObtainable(obtainable)
	queue_free()
