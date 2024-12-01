extends Node2D

const rice_scene = preload("res://scenes/rice_game/rice.tscn")
const bowl_radius = 263

var rice = []

var bowl_following_mouse = false

var best_position: Vector2 = Vector2.ZERO
var best_count = 0

var target_count = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_add_rice(target_count)
	
	_find_best_answer()
	if best_count == 0:
		print("couldn't find a good circle, wtf")
	
func _add_rice(count):
	for i in count:
		var x = randf_range(0.0, $rice_margin.position.x)
		var y = randf_range(0.0, $rice_margin.position.y)
		var r = rice_scene.instantiate()
		r.position = Vector2(x, y)
		self.add_child(r)
		rice.append(r)
		
func set_difficulty(diff: int):
	match diff:
		0: target_count = 40
		1: target_count = 80
		2: target_count = 120
		
		

func enable_input(enabled: bool):
	bowl_following_mouse = enabled
	

func _find_best_answer():
	var points: Array[Vector2] = []
	for r in rice:
		points.append(r.position)
	var max_covered = 0
	var best_circle = null
	
	# Brute force exploration with some optimization
	for i in range(points.size()):
		for j in range(i + 1, points.size()):
			# Try circle centered between two points
			var center = (points[i] + points[j]) / 2.0
			var covered = _count_points_in_circle(points, center, bowl_radius)
			
			if covered > max_covered:
				max_covered = covered
				best_circle = center
	
	# Try individual point centers as well
	for point in points:
		var covered = _count_points_in_circle(points, point, bowl_radius)
		if covered > max_covered:
			max_covered = covered
			best_circle = point
	
	best_count = max_covered
	best_position = best_circle


func _count_points_in_circle(points: Array[Vector2], center: Vector2, radius: float) -> int:
	var count = 0
	for point in points:
		if point.distance_to(center) <= radius:
			count += 1
	return count


func _highlight_in_circle_rice(pos):
	for r in rice:
		r.highlight(r.position.distance_to(pos) > bowl_radius)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _show_results():
	var user_pos = $BowlShadow.position
	var in_circle = 0
	for r in rice:
		if r.position.distance_to(user_pos) <= bowl_radius:
			in_circle += 1
	
	$ResultLabel.text = "You got %d in the circle! (out of best possible %d)" % [in_circle, best_count]
	$ResultLabel.show()
	
	
	await get_tree().create_timer(2.0).timeout
	var percentage = float(in_circle) / float(best_count) * 100
	if percentage >= 90:
		Signals.minigame_over.emit(2)
	elif percentage >= 80:
		Signals.minigame_over.emit(1)
	else:
		Signals.minigame_over.emit(0)

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# print("Mouse Click at: ", event.position)
		if bowl_following_mouse:
			bowl_following_mouse = false
			
			var t = create_tween()
			t.tween_property($Bowl, "position", $BowlShadow.position, 1.0).set_trans(Tween.TRANS_CIRC)
			t.tween_callback(_show_results)
			
			$Thud.play()
			
	elif event is InputEventMouseMotion:
		# print("Mouse Motion at: ", event.position)
		if bowl_following_mouse:
			var pos = get_local_mouse_position()
			pos = pos.clamp($mouse_clamp_min.position, $mouse_clamp_max.position)
			$BowlShadow.position = pos
			_highlight_in_circle_rice(pos)
			$Bowl.position = pos + Vector2(700, 200)
