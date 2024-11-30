extends Node2D

var fishScene  = preload("res://scenes/aquarium/fish/fish.tscn") 
var pufferScene  = preload("res://scenes/aquarium/fish/puffer.tscn") 
var lobsterScene  = preload("res://scenes/aquarium/lobster.tscn") 
var x = 1;
var y = 1;
var amp = 2;

var difficulty = 1;

func set_difficulty(diff):
	difficulty = diff

# Hardcoded everything, sorry
func _ready() -> void:
	var array = [fishScene, pufferScene, fishScene, pufferScene]
	$Cat/Blackout/Hand.fish_total = (difficulty + 2)
	for n in (difficulty + 2):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		x = randi_range(1, -10)
		amp = randi_range(520,900)
		var fishSelect = randi_range(0,3)
		var fish = array[fishSelect].instantiate()
		self.add_child(fish)
		fish.translate(Vector2(1, 1) * amp)
		
	for n in (difficulty + 2):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		x = randi_range(1, -10)
		amp = randi_range(520,900)

		var lobster = lobsterScene.instantiate()
		lobster.difficulty = difficulty;
		self.add_child(lobster)
		lobster.translate(Vector2(1, 1) * amp)
