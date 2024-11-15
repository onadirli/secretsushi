extends Area2D

var dx: Vector2 = Vector2.RIGHT
var speed: int = 3;

var zoneStack: Array[Area2D] = []

var score = 0

var score_label: Label
var action_label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	score_label = get_parent().get_node('Score')
	action_label = get_parent().get_node('ActionText')

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.is_action('chop'):
			_on_chop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
		action_label.text = 'Perfect!'
		score += 5
		zoneStack[1].get_parent().queue_free()
		
	elif isNormalChop:
		action_label.text = 'Normal chop'
		score += 1
		zoneStack[0].get_parent().queue_free()
	else:
		action_label.text = 'Get gud scrub'
		
	score_label.text = str(score)
	

func _on_area_entered(area):
	zoneStack.push_back(area)


func _on_area_exited(area):
	zoneStack.pop_back()


func _on_timer_timeout():
	action_label.text = ''
