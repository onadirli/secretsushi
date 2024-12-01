extends StaticBody2D

var fishScene  = preload("res://scenes/chopper/fish.tscn") 
var yellowfishScene  = preload("res://scenes/chopper/yellowfish.tscn") 
var instance

var time = 0
var coll_layer = 2;
var difficulty = 1;
var time_remaining = 15
var timing = true;

var fish_missed = 0;

func set_difficulty(difficulty):
	self.difficulty = difficulty
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_remaining -= delta
	get_parent().get_node("UserInterface").get_node("Time").set_time(time_remaining);
	
	if time_remaining < 0 && timing:
		timing = false

		# Probably set win loss based on fish missing
		print("GG" + str(fish_missed))
		
	var array = [fishScene, yellowfishScene]
	
	time += 1
	if time == (180 - (30 * difficulty)):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var fishSelect = randi_range(0,1)
		var fish = array[fishSelect].instantiate()
				
		var shape = $SpawnShape
		var x = randi_range(-1 * shape.shape.size.x, shape.shape.size.x)
		var speed = randi_range(800,1150)
		
		var launch = Vector2(((x/2) * -1)/shape.shape.size.x,-1)
		fish.linear_velocity = launch * speed
		
		var rotation = randf_range(-5,5)
		fish.angular_velocity = rotation
		fish.position = self.position
		fish.position.x += x/2
		fish.difficulty = difficulty;
		fish.rotation = x;
		fish.gravity_scale = 0.8
		fish.set_collision_layer_value(coll_layer, true)
		coll_layer += 1;
		
		get_parent().add_child(fish)
		time = 0
