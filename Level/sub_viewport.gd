extends SubViewport

@onready var camera_2d: Camera2D = $Camera2D
@onready var player: Node2D = $"../../../player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_2d.position = player.position
