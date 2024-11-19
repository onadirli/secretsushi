class_name Planet
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
		if retracting != true:
			extending = true
			retracting = false


func _on_body_entered(body):
	var bottom_boundary = self.get_parent().get_parent().get_node("BottomBoundary")
	var left_boundary = self.get_parent().get_parent().get_node("LeftBoundary")
	var right_boundary = self.get_parent().get_parent().get_node("RightBoundary")
	
	if body == self.get_parent():	
		_enter_rotation()
	elif body == left_boundary || body == right_boundary || body == bottom_boundary:
		_enter_retracting()
		
func _on_area_entered(area):
	if fish_hooked == null && area is Fish:
		fish_hooked = area
	if area is Lobster:
		extending = false
		retracting = true
		get_parent().get_parent().get_node("UserInterface").get_node("Score")._on_lobster_touched();
	
func _enter_rotation():
	self.position = Vector2(0,0)
	retracting = false
	extending = false
	if (fish_hooked != null):
		fish_hooked.consumed = true
		fish_hooked = null
		#I read doing this is super shit, I think I'm supposed to use signals but just trying to finish
		get_parent().get_parent().get_node("UserInterface").get_node("Score")._on_fish_consumed();

func _enter_retracting():
	extending = false
	retracting = true

func _process(delta: float) -> void:
	if !extending && !retracting:
		n += delta * 1.5
		self.rotation = sin(n) + 33
	elif(extending):
		self.translate(Vector2(1,0).rotated(self.rotation) * 3)
	elif(retracting):
		self.translate(Vector2(-1,0).rotated(self.rotation) * 3)
	
	if fish_hooked != null:
		fish_hooked.hooked = true
		extending = false
		retracting = true
		fish_hooked.translate(Vector2(-1,0).rotated(self.rotation) * 3)
		
	pass

	
