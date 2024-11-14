extends Area2D

var dx: Vector2 = Vector2.RIGHT
var speed: int = 6;

var zoneStack: Array[Area2D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("chop"):
		_on_chop()
	
	position = position + dx * speed
	
	var right_marker = get_parent().get_node("RightMarker")
	var left_marker = get_parent().get_node('LeftMarker')
	
	var is_beyond_right_marker = position >= right_marker.position
	var is_beyond_left_marker = position <= left_marker.position
	
	var should_change_dir = is_beyond_right_marker or is_beyond_left_marker
	
	if should_change_dir:
		dx = -dx
		
func _on_chop():
	var size = zoneStack.size()
	
	var isNormalChop = size == 1
	var isPerfectChop = size == 2
	
	if isPerfectChop:
		print('perfect!')
		zoneStack[1].get_parent().queue_free()
		
	elif isNormalChop:
		print('normal')
		zoneStack[0].get_parent().queue_free()
	else:
		print('miss!')
	

func _on_area_entered(area):
	zoneStack.push_back(area)


func _on_area_exited(area):
	zoneStack.pop_back()
