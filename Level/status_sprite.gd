extends Control

var type: int = 0
var status: int = 0
@onready var anims: AnimationPlayer = $AnimationPlayer
var lastStatus: int
@onready var deathLabel: Label = $deathLabel
@onready var deathAnims: AnimationPlayer = $deathLabelAnims


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if lastStatus == status:
		lastStatus = status
	else:
		lastStatus = status
		statusChanged()
	

func statusChanged():
	if status > 0:
		anims.play("appear")
	else:
		match type:
			0:
				deathLabel.text = "EXPENDED"
			1:
				deathLabel.text = "UNUSED"
			2:
				deathLabel.text = "BANK BROKE"
			3:
				deathLabel.text = "MONEY LOST"
			4:
				deathLabel.text = "MONEY GAINED"
			5:
				deathLabel.text = "NEGATIVE EFFECT DOUBLED"
		deathAnims.play("wobble")
		anims.play("die")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"die":
			status = 0
			deathLabel.hide()
			deathAnims.stop()
			self.hide()
		"appear":
			anims.play("hover")
