extends Node2D

var fishScene  = preload("res://scenes/aquarium/fish/fish.tscn") 
var pufferScene  = preload("res://scenes/aquarium/fish/puffer.tscn") 
var lobsterScene  = preload("res://scenes/aquarium/lobster.tscn") 
var yamp;
var xamp;

var difficulty = 1;

func set_difficulty(diff):
	difficulty = diff

# Hardcoded everything, sorry
func _ready() -> void:
	var array = [fishScene, pufferScene, fishScene, pufferScene]
	for n in 3:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		xamp = randi_range(200,1700)
		yamp = randi_range(620,900)
		var fishSelect = randi_range(0,3)
		var fish = array[fishSelect].instantiate()
		self.add_child(fish)
		fish.translate(Vector2(1 * xamp, 1 * yamp))
		
	for n in (difficulty + 2):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		xamp = randi_range(200,1700)
		yamp = randi_range(520,800)

		var lobster = lobsterScene.instantiate()
		lobster.difficulty = difficulty;
		self.add_child(lobster)
		lobster.translate(Vector2(1 * xamp, 1 * yamp))
