extends CSGCylinder3D

@onready var level: Node3D = $"../.."

var spinning: bool = false
var spin_velocity: float = 0
var friction: float = 0.98

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#rotation.y += 1 * delta
	if spinning:
		if spin_velocity != 0:
			var currentAngle = self.rotation
			currentAngle.y += spin_velocity * delta
			spin_velocity *= friction
			if spin_velocity < 0.01:
				spin_velocity = 0
				spinning = false
			self.rotation = currentAngle

func spin():
	spin_velocity = randf_range(200, 500)
	spinning = true
