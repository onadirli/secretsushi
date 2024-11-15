extends Area2D

@export var speed: int = 15

var dir = 1;

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	dir = randi_range(1,2)
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
	if dir == 1:
		self.translate(Vector2(1,0) * 0.7)	
	elif dir == 2:
		self.translate(Vector2(-1,0) * 0.7)	
	
