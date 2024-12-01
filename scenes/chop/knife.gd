extends Area2D

signal score_changed(old_value, new_value)
signal show_action_label(text)
signal miss
signal hit

var dx: Vector2 = Vector2.RIGHT
var zoneStack: Array[Area2D] = []

var score = 0

var are_controls_enabled = true

@export var speed: int = 2;
@onready var right_marker: Marker2D = get_parent().get_node('RightMarker')
@onready var left_marker: Marker2D = get_parent().get_node('LeftMarker')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not are_controls_enabled:
		return
		
	position = position + dx * speed
	
	var is_beyond_right_marker = position >= right_marker.position
	var is_beyond_left_marker = position <= left_marker.position
	
	var should_change_dir = is_beyond_right_marker or is_beyond_left_marker
	
	if should_change_dir:
		dx = -dx
		
func chop():
	var size = zoneStack.size()
	
	var isNormalChop = size == 1
	var isPerfectChop = size == 2
	
	var old_score = score
	var is_hit = false
	
	# Figure out perfect chop or okay chop or bad chop
	var label_text = ''
	if isPerfectChop:
		label_text = 'Perfect!'
		score += 5
		zoneStack[1].get_parent().queue_free()
		is_hit = true
		
	elif isNormalChop:
		label_text = 'Not bad'
		score += 3
		zoneStack[0].get_parent().queue_free()
		is_hit = true
	else:
		label_text = 'This will not do'

	# Display action label	
	show_action_label.emit(label_text)
	
	# Update score
	score_changed.emit(old_score, score)
	
	if is_hit:
		hit.emit()
	else:
		miss.emit()
	

func toggle_controls(enabled: bool = true):
	are_controls_enabled = enabled

func _on_area_entered(area):
	zoneStack.push_back(area)


func _on_area_exited(area):
	zoneStack.pop_back()
