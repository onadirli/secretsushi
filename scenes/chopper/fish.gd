extends RigidBody2D

var fishbit  = preload("res://scenes/chopper/fish_bit.tscn") 
var slice = preload("res://scenes/chopper/slice.tscn")

@export var fishbit1_texture: String
@export var fishbit2_texture: String

var clicks_to_kill = 1;
# set this from aquarium instead
var difficulty = 1;
var curr_clicks = 0;
var initial_y: int;
var lost = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	clicks_to_kill *= 1
	initial_y = self.position.y

func _process(delta: float) -> void:
	if self.position.y > initial_y && !lost:
		lost = true
		get_parent().get_node("BottomSpawn").fish_missed += 1
		self.queue_free()
		
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		curr_clicks += 1
		$FishAnimation.play("damage")
		if curr_clicks == clicks_to_kill:
			var slice_node = slice.instantiate()
			slice_node.position = position
			get_parent().add_child(slice_node)
			
			
			
			get_parent().get_node("UserInterface").get_node("Score")._on_fish_cut();
			self.queue_free()
			var fishbit1 = fishbit.instantiate()
			var fishbit2 = fishbit.instantiate()
			
			fishbit1.get_node("FishSprite").texture = load(fishbit1_texture)
			fishbit1.get_node("FishSprite").scale = Vector2(0.7,0.7)
			fishbit1.get_node("FishSprite").rotation_degrees = self.rotation_degrees;
			fishbit2.get_node("FishSprite").texture = load(fishbit2_texture)
			fishbit2.get_node("FishSprite").scale = Vector2(0.7,0.7)
			fishbit2.get_node("FishSprite").rotation_degrees = self.rotation_degrees;
			
			var launch_modifier = randf_range(-100,100)
			
			fishbit1.linear_velocity = (self.linear_velocity + Vector2(launch_modifier,-300))
			fishbit1.angular_velocity = self.angular_velocity * randf_range(1.7,2.7)
			fishbit2.linear_velocity = (self.linear_velocity + Vector2(-launch_modifier,-300))
			fishbit2.angular_velocity = self.angular_velocity * randf_range(1.7,2.7) 
			
			fishbit1.position = self.position + Vector2(randi_range(-30,30),0)
			fishbit2.position = self.position + Vector2(randi_range(-30,30),0)

			fishbit1.gravity_scale = 0.8
			fishbit2.gravity_scale = 0.8

			get_parent().add_child(fishbit1)
			get_parent().add_child(fishbit2)
