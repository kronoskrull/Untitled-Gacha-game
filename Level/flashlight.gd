extends OmniLight3D

# Simple script for a flickering flashlight. Takes a noise texture, returns a noise value at 
# a coordinate determined by delta every frame. flashMult is to allow player control over it,
# remove the multiplier entirely for spotlights or ambient lighting.

@export var noise: NoiseTexture2D
var time_passed: float = 0.0



func _process(delta: float) -> void:
	time_passed += delta
	var sampled_noise = noise.noise.get_noise_1d(time_passed)
	sampled_noise = abs(sampled_noise)
	
	light_energy = sampled_noise * $"../../..".flashMult
