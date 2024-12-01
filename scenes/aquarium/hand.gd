class_name Planet
extends Area2D

var n:float = 0.0

var extending:bool = false
var retracting:bool = false
var fish_hooked
var init_position

var fish_count = 0
var time_seconds
var timing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enable_input(true)
	self.body_entered.connect(_on_body_entered)
	self.area_entered.connect(_on_area_entered)
	pass
	
func enable_input(enable):
	if enable:
		timing = true
		time_seconds = 20.0
		set_process_input(enable) 

func _input(ev):
	if Input.is_key_pressed(KEY_SPACE):
		if retracting != true:
			_enter_extending()

func _on_body_entered(body):
	var bottom_boundary = self.get_parent().get_parent().get_parent().get_node("BottomBoundary")
	var left_boundary = self.get_parent().get_parent().get_parent().get_node("LeftBoundary")
	var right_boundary = self.get_parent().get_parent().get_parent().get_node("RightBoundary")
	
	if body == self.get_parent().get_parent():	
		_enter_rotation()
	elif body == left_boundary || body == right_boundary || body == bottom_boundary:
		_enter_retracting()
		
func _on_area_entered(area):
	if !retracting && fish_hooked == null && (area is Fish || area is Puffer):
		$Splash.play()
		fish_hooked = area
	if !retracting && area is Lobster:
		$Snap.play()
		$Pain.play()
		_enter_retracting();
		get_parent().get_parent().get_parent().get_node("UserInterface").get_node("Score")._on_lobster_touched();
		
func _enter_rotation():
	self.position = init_position;
	retracting = false
	extending = false
	if (fish_hooked != null):
		fish_hooked.consumed = true
		fish_hooked = null
		fish_count += 1
		#I read doing this is super shit, I think I'm supposed to use signals but just trying to finish
		get_parent().get_parent().get_parent().get_node("UserInterface").get_node("Score")._on_fish_consumed();

func _enter_extending():
	extending = true
	retracting = false
	

func _enter_retracting():
	extending = false
	retracting = true

func _process(delta: float) -> void:
	if time_seconds < 0 && timing == true:
		timing = false
		print("GAME END")
		if fish_count == 3:
			# print ("Perfect")
			Signals.minigame_over.emit(2)
		if fish_count == 2:
			# print ("Win")
			Signals.minigame_over.emit(1)
		if fish_count <= 1:
			# print ("Lose")
			Signals.minigame_over.emit(0)
	if timing:
		get_parent().get_parent().get_parent().get_node("UserInterface").get_node("Time").set_time(time_seconds);
		time_seconds -= delta
	if !extending && !retracting:
		init_position = self.position;
		n += delta * 1.5
		self.rotation = sin(n) + 33
	elif(extending):
		self.translate(Vector2(1,0).rotated(self.rotation) * 6)
	elif(retracting):
		self.translate(Vector2(-1,0).rotated(self.rotation) * 6)
	
	if fish_hooked != null:
		fish_hooked.hooked = true
		fish_hooked.translate(Vector2(-1,0).rotated(self.rotation) * 6)
		_enter_retracting();
