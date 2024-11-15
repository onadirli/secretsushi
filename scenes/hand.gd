extends Area2D

var n:float = 0.0
@export_range(0, PI/2) var amp:float = 0.0

var extending:bool = false
var retracting:bool = false
var velocity = Vector2()
var fish_hooked;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true) 
	self.body_entered.connect(_on_body_entered)
	self.area_entered.connect(_on_area_entered)
	pass

func _input(ev):
	if Input.is_key_pressed(KEY_SPACE):
		extending = true
		retracting = false
		pass

func _on_body_entered(body):
	var bottom_boundary = self.get_parent().get_parent().get_node("BottomBoundary")
	var left_boundary = self.get_parent().get_parent().get_node("LeftBoundary")
	var right_boundary = self.get_parent().get_parent().get_node("RightBoundary")
	
	if body == self.get_parent():	
		_enter_rotation()
	elif body == left_boundary || body == right_boundary || body == bottom_boundary:
		_enter_retracting()
		
func _on_area_entered(area):
	var fish = self.get_parent().get_parent().get_node("Fish")
	if area == fish:
		fish_hooked = area
	
func _enter_rotation():
	self.position = Vector2(0,0)
	retracting = false
	extending = false
	fish_hooked = null

func _enter_retracting():
	extending = false
	retracting = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !extending && !retracting:
		n += delta
		self.rotation = sin(n) + 33
	elif(extending):
		self.translate(Vector2(1,0).rotated(self.rotation) * 2)
	elif(retracting):
		self.translate(Vector2(-1,0).rotated(self.rotation) * 1.5)
	
	if fish_hooked != null:
		var dist = fish_hooked.global_position - self.global_position
		print (dist)
		extending = false
		retracting = true
		fish_hooked.position = self.position + dist
		print(fish_hooked.position);
		
	pass

	
