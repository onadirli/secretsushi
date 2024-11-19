extends Node2D

var fishScene  = preload("res://scenes/aquarium/fish.tscn") 
var lobsterScene  = preload("res://scenes/aquarium/lobster.tscn") 
var x = 1;
var y = 1;
var amp = 1;

# Hardcoded everything, sorry
func _ready() -> void:
	for n in 4:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		x = randi_range(1, -10)
		y = randi_range(4, -1)
		amp = randi_range(1,45)

		var fish = fishScene.instantiate()
		self.add_child(fish)
		fish.translate(Vector2(x, y) * amp)
		
	for n in 4:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		x = randi_range(1, -10)
		y = randi_range(4, -1)
		amp = randi_range(1,45)

		var lobster = lobsterScene.instantiate()
		self.add_child(lobster)
		lobster.translate(Vector2(x, y) * amp)
