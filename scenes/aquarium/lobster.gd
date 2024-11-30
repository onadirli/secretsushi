class_name Lobster
extends Area2D

@export var speed: float = 1

var dir = 1;
var hooked = false;
var consumed = false;

var difficulty = 1;

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	dir = randi_range(1,2)
	
	difficulty += randf_range(0,difficulty - 1)
	speed += randf_range(-0.2, 0.2);
	
	self.body_entered.connect(_on_body_entered)
	pass

func _on_body_entered(body):
	var left_boundary = self.get_parent().get_node("LeftBoundary")
	var right_boundary = self.get_parent().get_node("RightBoundary")
	if body == left_boundary:
		_change_right()
	elif body == right_boundary:
		_change_left()

func _change_left():
	dir = 2
	
func _change_right():
	dir = 1
	
func _process(delta: float) -> void:
	if !hooked:
		if dir == 1:
			$Crab.scale.x = -0.2
			self.translate(Vector2(1,0) * (speed + difficulty - 1))	
		elif dir == 2:
			$Crab.scale.x = 0.2
			self.translate(Vector2(-1,0) * (speed + difficulty - 1))	
	elif consumed:
		self.queue_free()
	
